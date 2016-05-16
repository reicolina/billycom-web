class BillingSession < ActiveRecord::Base
  acts_as_tenant(:site)
  mount_uploader :csv, FileUploader
  attr_accessible :name, :billing_date, :due_date, :start_number, :pending_flag
  belongs_to :site
  has_many :temp_calls
  has_many :bills, :dependent => :destroy
  has_and_belongs_to_many :call_detail_records
  before_create :no_pending_sessions
  # before_create :has_temp_calls
  validates_presence_of :name
  validates_uniqueness_to_tenant :name
  validates_presence_of :billing_date
  validates_presence_of :due_date
  validates_presence_of :call_detail_records, :on => :create
  validates_presence_of :start_number

  EMAILS_NOT_SENT = 0
  EMAILS_IN_PROGRESS = 1
  EMAILS_SENT = 2

  def no_pending_sessions
    return if BillingSession.count(:conditions => ['pending_flag = true']) == 0
    errors[:base] << "Cannot start a billing session. Another session is in progress."
    false
  end

  # def has_temp_calls
  #   return if TempCall.count(:conditions => ['rated = false']) > 0
  #   errors[:base] << "Cannot start a billing session. Call usage import process is not completed or hasn't started at all."
  #   false
  # end

  def batch_email_process(billing_session_id)
    Rails.logger.info "BATCH_EMAIL: Executing batch email"
    billing_session = BillingSession.find(billing_session_id)
    ActsAsTenant.with_tenant(billing_session.site) do
      begin
        #Email every bill within the billing session
        billing_session.bills.each do |bill|
          if not bill.account.billing_email.nil? and not billing_session.site.from_email.nil?
            if bill.account.billing_email.length > 0  and billing_session.site.from_email.length > 0
              # if not bill.pdf.read.length > Source::Application.config.email_attachment_max_size
                BillMailer.invoice_email(bill.account.billing_email, bill, billing_session.site).deliver
                bill.emailed = true
                bill.save
                bill = nil
              # end
            end
          end
        end
      rescue => e
        Rails.logger.error "ERROR: problem while executing batch_emailing rake task: " + e.message
        Rails.logger.error e.backtrace.join("\n")
      end
      Rails.logger.info "BATCH_EMAIL: Setting batch email to completed"
      billing_session.batch_email_status = BillingSession::EMAILS_SENT
      billing_session.save
    end
  end
  handle_asynchronously :batch_email_process, :queue => 'emailing'

  def do_billing(billing_session_id)
      self.class.connection.clear_query_cache
      Rails.logger.info "BILLING_LOG: cleared the cache so this worker can load the latest data"
      billing_session = BillingSession.find(billing_session_id)
      ActsAsTenant.with_tenant(billing_session.site) do
        begin
          Rails.logger.info "BILLING_LOG: starting billing process for: " +  ActsAsTenant.current_tenant.name.to_s + "(" + ActsAsTenant.current_tenant.id.to_s + ")"
          Rails.logger.info "BILLING_LOG: setting billing session processing flag"
          billing_session.processing_flag = true
          billing_session.status = "Reading CDRs"
          billing_session.save
          #=================
          #Archive old bills
          #=================
          # TODO: Re-build archiving process here
          # if billing_session.id >= 3 #we keep the last 2 billing sessions (not including the is being created)
          #   session_id = billing_session.id - 2
          #   billing_session.connection.execute("update bills set pdf = null, csv = null where billing_session_id < " + session_id.to_s + " and pending_flag = 0")
          #   session_id = nil
          # end
          #=============================
          #First, do the LD calls rating
          #=============================
          billing_session.call_detail_records.each do |cdr_file|
            Rails.logger.info "BILLING_LOG: Retrieving CDR for provider: " + cdr_file.provider.name.to_s
            cdr_file.provider.import_cdr(open(cdr_file.cdr.url))
          end
          cdr_file = nil
          Rails.logger.info "BILLING_LOG: performing call rating"
          billing_session.status = "Rating calls"
          billing_session.save
          do_rating
          #==================
          #Now do the Billing
          #==================
          billing_session.status = "Creating billing records"
          billing_session.save
          Rails.logger.info "BILLING_LOG: doing the billing"
          #Get the active accounts
          Rails.logger.info "BILLING_LOG: gettting active accounts"
          accounts = Account.find(:all, :select => 'id', :conditions => ['active = true'], :include => :taxes, :order => :title)
          #Generate a bill for each active account
          Rails.logger.info "BILLING_LOG: generate a bill for each active client"
          accounts.each do |account|
            Rails.logger.info "BILLING_LOG: working on client id: " + account.id.to_s + " from company: " + ActsAsTenant.current_tenant.name.to_s
            bill = Bill.new
            #Get the bill number
            Rails.logger.info "BILLING_LOG: getting bill number"
            number = Bill.maximum(:number, :conditions => 'billing_session_id = ' + billing_session.id.to_s)
            if number.nil?
              bill.number = billing_session.start_number
            else
              bill.number = number + 1
            end
            #Get the rest of the stuff (account_id, billing_session_id)
            Rails.logger.info "BILLING_LOG: getting the rest of the stuff (account_id, billing_session_id)"
            bill.account_id = account.id
            bill.billing_session_id = billing_session.id
            Rails.logger.info "BILLING_LOG: saving the bill"
            #Save the bill
            if bill.save
              Rails.logger.info "BILLING_LOG: bill saved"
              #========================================
              #Move billed charges to the billed tables
              #========================================
              billing_session.status = "Moving billing data"
              billing_session.save
              Rails.logger.info "BILLING_LOG: moving billed charges to the billed tables"
              #1.-Calls
              Rails.logger.info "BILLING_LOG: moving billed calls"
              move_billed_calls(bill.id, account.id)
              #2.-Lines
              Rails.logger.info "BILLING_LOG: moving billed lines"
              billing_session.connection.execute("insert into billed_lines(`number`, `type_of_line`, `use`, `group`, `sequence`, `amount_charged`, `bill_id`, `created_at`, `updated_at`, `site_id`) select `number`, `type_of_line`, `use`, `group`, `sequence`, `line_rate`, " + bill.id.to_s + ", current_timestamp(), current_timestamp(), `site_id` from `lines` where `account_id` = " + account.id.to_s + " and `active` = true and `port_date` <= '" + billing_session.billing_date.to_s + "'" + " and `site_id` = " + ActsAsTenant.current_tenant.id.to_s)
              #3.-Services
              Rails.logger.info "BILLING_LOG: moving billed services"
              billing_session.connection.execute("insert into billed_services(`type_of_service`, `use`, `amount_charged`, `bill_id`, `created_at`, `updated_at`, `site_id`) select `type_of_service`, `use`, `rate`, " + bill.id.to_s + ", current_timestamp(), current_timestamp(), `site_id` from other_services where `account_id` = " + account.id.to_s + " and `port_date` <= '" + billing_session.billing_date.to_s + "'" + " and `site_id` = " + ActsAsTenant.current_tenant.id.to_s)
              #4.-Adjustments
              Rails.logger.info "BILLING_LOG: moving billed adjustments"
              billing_session.connection.execute("insert into billed_adjustments(`description`, `amount_charged`, `bill_id`, `created_at`, `updated_at`, `site_id`) select `description`, `amount`, " + bill.id.to_s + ", current_timestamp(), current_timestamp(), `site_id` from adjustments where `account_id` = " + account.id.to_s + " and `apply_on` = '" + billing_session.billing_date.to_s + "'" + " and `site_id` = " + ActsAsTenant.current_tenant.id.to_s)
              #5.-Taxes
              Rails.logger.info "BILLING_LOG: moving billed taxes"
              total_charges = BilledCall.sum(:amount_charged, :conditions => "bill_id = " + bill.id.to_s) + BilledLine.sum(:amount_charged, :conditions => "bill_id = " + bill.id.to_s) + BilledService.sum(:amount_charged, :conditions => "bill_id = " + bill.id.to_s) + BilledAdjustment.sum(:amount_charged, :conditions => "bill_id = " + bill.id.to_s)
              account.taxes.each do |tax|
                Rails.logger.info "BILLING_LOG: saving total " + tax.name.to_s + " tax charges"
                billed_tax = BilledTax.new
                billed_tax.name = tax.name
                billed_tax.rate = tax.rate
                billed_tax.amount_charged = ("%.#{ActsAsTenant.current_tenant.decimals}f" % billed_tax.calculate_amount(total_charges))
                billed_tax.bill_id = bill.id
                billed_tax.save
                billed_tax = nil
              end
              total_charges = nil
              tax = nil
            end
             #Do some clean up
             Rails.logger.info "BILLING_LOG: cleaning up memory"
             bill = nil
             account = nil
             number = nil
          end
          Rails.logger.info "BILLING_LOG: deleting billed temp_calls"
          TempCall.delete_all("stranded = false")
          #Now generate the pdfs and csvs
          billing_session.status = "Generating reports"
          billing_session.save
          Rails.logger.info "BILLING_LOG: generating PDFs and CSVs"
          generate_files(billing_session)
           # generate summary report
          billing_session.status = "Generating summary"
          billing_session.save
          billing_session = BillingSession.find(billing_session.id) #Need to reload Billing Session, otherwise Carrierwave gem will fail!
          generate_summary_report(billing_session)
          # remove the bills detail records (don't need them any more)
          billing_session.status = "Removing temporary data"
          billing_session.save
          Rails.logger.info "BILLING_LOG: removing bills details"
          BilledCall.delete_all("site_id = " + ActsAsTenant.current_tenant.id.to_s)
          BilledLine.delete_all("site_id = " + ActsAsTenant.current_tenant.id.to_s)
          BilledService.delete_all("site_id = " + ActsAsTenant.current_tenant.id.to_s)
          BilledAdjustment.delete_all("site_id = " + ActsAsTenant.current_tenant.id.to_s)
          BilledTax.delete_all("site_id = " + ActsAsTenant.current_tenant.id.to_s)
          # remove CDRs
          Rails.logger.info "BILLING_LOG: removing CDRs from remote storage"
          billing_session.call_detail_records.each do |cdr_file|
            cdr_file.destroy
          end
          cdr_file = nil
          Rails.logger.info "BILLING_LOG: removing billing session pending and processing flag"
          billing_session.pending_flag = false
          billing_session.processing_flag = false
          billing_session.status = "Ready"
          billing_session.save
          billing_session = nil
        rescue => e
            Rails.logger.error "ERROR: problem while executing do_billing: " + e.message
            Rails.logger.error e.backtrace.join("\n")
            if not billing_session.nil?
              billing_session.pending_flag = false
              billing_session.processing_flag = false
              billing_session.failed = true
              billing_session.status = e.message
              billing_session.save
            end
        end
      end
      Rails.logger.info "MEMORY_MANAGEMENT: [do_billing] starting garbage collector"
      GC.start #force garbage collector
  end
  handle_asynchronously :do_billing, :queue => 'billing'

end

def do_rating
  require 'activerecord-import'
  Rails.logger.info "BILLING_LOG: Rating calls for: " +  ActsAsTenant.current_tenant.name.to_s + "(" + ActsAsTenant.current_tenant.id.to_s + ")"
  isCustomFlowIig = ActsAsTenant.current_tenant.name.include? 'Internet Information Group'
  if isCustomFlowIig
    Rails.logger.info "CUSTOM_FLOW: Running custom flow (do_rating) for IIG"
  end
  n=0
  calls = []
  TempCall.find_each do |call|
      begin
        #Get the line record from the number
        line = Line.search_line(call.orig_tn) #find_by_number(call.orig_tn, :select => 'account_id, rating_plan_id', :include => :account)
        if not line.nil?
          if line.account.active?
            #Set the account id
            call.account_id = line.account_id
            #Get the call type
            type_info = call.get_call_type_info
            if type_info.nil?
              #No call type...no rate
              call.amount_charged = nil
            else #Now let's get to the fun stuff...do the rating!
              call.call_type = type_info.name #first set the call type name
              if isCustomFlowIig
                if call.term_tn.start_with? "13"
                  call.amount_charged = 0.2727
                elsif (call.term_tn.start_with? "614") &&  (call.duration_sec <= 30)
                  # the 614 numbers are Mobile and are 26c per minute but have a minimum "flagfall" of 11.8c
                  call.amount_charged = 0.118
                elsif call.term_tn.start_with?("612", "613", "617", "618")
                  # Australian Fixed - they should be billed at 10.909c
                  call.amount_charged = 0.1091
                elsif (call.term_tn.start_with? "4") && call.call_type = "To Mobile" &&  (call.duration_sec <= 30)
                  # NBN Mobile have a minimum "flagfall" of 11.8c
                  call.amount_charged = 0.12
                elsif call.term_tn.start_with?("2", "3", "7", "8") && call.call_type = "National" &&  (call.duration_sec <= 30)
                  # NBN Australian calls (NBN) have a minimum "flagfall" of 12c
                  call.amount_charged = 0.12
                else
                  call.amount_charged = do_rating_from_call_type_info(type_info,call,line)
                end
                Rails.logger.info "CUSTOM_FLOW: custom amount charged: " + call.amount_charged.to_s
              else
                call.amount_charged = do_rating_from_call_type_info(type_info,call,line)
              end
              #Apply the fixed minimum charge
              if not (call.amount_charged.nil?)
                if call.amount_charged < line.rating_plan.minimum_charge_rating.fixed_minimum_charge
                    call.amount_charged = line.rating_plan.minimum_charge_rating.fixed_minimum_charge
                end
              end
            end
            #Mark as rated
            if not (call.account_id.nil?) and not (call.amount_charged.nil?)# and not call.billing_session_id.nil?
              call.rated = true
              if call.stranded == true #This is for stranded calls that were succesfully rated
                call.stranded = false
              end
              # call.save
            else
              call.stranded = true
              Rails.logger.warn "WARNING: Call marked as stranded. No client or amount charged found"
              # call.save
            end
          else
            call.stranded = true
            Rails.logger.warn "WARNING: Call marked as stranded. Client is NOT active"
            # call.save
          end
        else
          call.stranded = true
          Rails.logger.warn "WARNING: Call marked as stranded. No line found"
          # call.save
        end
      rescue => e
        Rails.logger.error "ERROR: problem while executing do_rating: " + e.message
        Rails.logger.error e.backtrace.join("\n")
        #Do nothing, work with the next record.
        call.stranded = true
        # call.save
      end
    calls.push call
    n=n+1
    if n%Source::Application.config.gc_start_loop_count==0
      Rails.logger.info "LOOP_COUNT: [do_rating] " + n.to_s + " loops"
      TempCall.import calls, :on_duplicate_key_update => [:account_id, :amount_charged, :call_type, :rated, :stranded]
      calls = []
      #GC.start
    end
  end
  if (not calls.nil?) && (calls.length > 0)
    Rails.logger.info "INFO: [do_rating] executing update for the rest of the items left"
    TempCall.import calls, :on_duplicate_key_update => [:account_id, :amount_charged, :call_type, :rated, :stranded]
  end
  line = nil
  type_info = nil
  calls = nil
end

def do_rating_from_call_type_info(type_info,call,line)
  if not line.rating_plan.cdr_charge_factor.nil? #individual markup?
    call.provider_charge * line.rating_plan.cdr_charge_factor
  elsif  not type_info.fixed_rate.nil? #fixed rate?
    if type_info.fixed_rate > 0 #TODO: we can probably ommit this 'if' to allow '0'
      type_info.fixed_rate
    end
  elsif not type_info.cdr_charge_factor.nil? #use charge from cdr?
    if  type_info.cdr_charge_factor > 0 #TODO: we can probably ommit this 'if' to allow '0'
      call.provider_charge * type_info.cdr_charge_factor
    end
  else
      get_rating_from_call_type(type_info,call,line)
  end
end

def get_rating_from_call_type(type_info,call,line)
  if type_info.call_type == CallTypeInfo::NON_OVERSEAS
    #Get the non overseas rate
    get_non_overseas_rating(call,line)
  else
    #Get the overseas rate
    get_overseas_rating(call,line,type_info.call_type)
  end
end

def get_non_overseas_rating(call,line)
  get_charge(line.rating_plan.local_plan.rate,call,line,line.rating_plan.local_plan.increment_in_seconds)
end

def get_overseas_rating(call,line,call_type)
  international_rate = line.rating_plan.international_plan.international_rates.find_by_number(call.term_tn,call_type)
  get_charge(international_rate.rate,call,line,international_rate.increment_in_seconds)
end

def get_charge(rate,call,line,increment)
  duration = get_duration(call.duration_sec,increment)
  if duration <= line.rating_plan.minimum_charge_rating.duration_sec
    get_minimum_rate(rate,line)
  else
    (duration * rate)/60
  end
end

#This will calculate the duration based on a given charge increment (in seconds)
def get_duration(actual_duration, increment)
  ((actual_duration.to_f/increment.to_f).ceil) * increment
end

def get_minimum_rate(rate,line)
  rate * (line.rating_plan.minimum_charge_rating.percentage/100)
end

def move_billed_calls(bill_id, account_id)
  n=0
  calls = []
  TempCall.where("rated = 1 and account_id = " + account_id.to_s).find_each do |call|
    if (not call.destination.nil?) && (not call.destination == "")
      call.destination = call.destination[0..27]
    end
    if call.code.nil?
      call.code = ""
    end
    if call.duration_sec.nil?
      call.duration_sec = 0
    end
    # BilledCall.create!(:orig_tn => call.orig_tn, :date => call.date, :time => call.time, :duration_sec => call.duration_sec, :destination => call.destination, :dest_prov_state => call.dest_prov_state, :term_tn => call.term_tn, :code => call.code, :amount_charged => call.amount_charged, :provider_id => call.provider_id, :bill_id => bill_id.to_s, :call_type => call.call_type)
    #Build the array
    calls.push "(" + [ActiveRecord::Base.connection.quote(call.orig_tn),ActiveRecord::Base.connection.quote(call.date),ActiveRecord::Base.connection.quote(call.time),call.duration_sec,ActiveRecord::Base.connection.quote(call.destination),ActiveRecord::Base.connection.quote(call.dest_prov_state),ActiveRecord::Base.connection.quote(call.term_tn),ActiveRecord::Base.connection.quote(call.code),call.amount_charged,call.provider_id,bill_id.to_s,ActiveRecord::Base.connection.quote(call.call_type),ActsAsTenant.current_tenant.id].join(", ") + ")"
    n=n+1
    if n%Source::Application.config.gc_start_loop_count==0
      Rails.logger.info "LOOP_COUNT: [move_billed_calls] " + n.to_s + " loops"
      sql = "INSERT INTO billed_calls (orig_tn, date, time, duration_sec, destination, dest_prov_state, term_tn, code, amount_charged, provider_id, bill_id, call_type, site_id) VALUES #{calls.join(", ")}".force_encoding("UTF-8")
      Rails.logger.info "INFO: [move_billed_calls] executing insert query for these " + Source::Application.config.gc_start_loop_count.to_s + " items"
      ActiveRecord::Base.connection.execute(sql)
      calls = []
      # GC.start
    end
  end
  if (not calls.nil?) && (calls.length > 0)
    sql = "INSERT INTO billed_calls (orig_tn, date, time, duration_sec, destination, dest_prov_state, term_tn, code, amount_charged, provider_id, bill_id, call_type, site_id) VALUES #{calls.join(", ")}".force_encoding("UTF-8")
    Rails.logger.info "INFO: [move_billed_calls] executing insert query for the rest of the items left"
    ActiveRecord::Base.connection.execute(sql)
  end
  calls = nil
end

def generate_files(billing_session)
  Rails.logger.info "BILLING_LOG: generating billing files for billing session: " + billing_session.name.to_s + " and company: " +  ActsAsTenant.current_tenant.name.to_s + "(" + ActsAsTenant.current_tenant.id.to_s + ")"
  billing_session.bills.each do |bill|
    generate_bill_files(bill)
  end
  bill = nil
  billing_session = nil
end

def generate_summary_csv(billing_session)
  require 'csv'
  Rails.logger.info "BILLING_LOG: Generating billing summary..."
  csv_string = CSV.generate do |csv|
    csv << ["invoice_number","client_number","client_name","calls_total_billed","lines_total_billed","services_total_billed","adjustments_total_billed","taxes_total_billed"]
    BillingSession.connection.select_rows("SELECT a.number as bill_number,
    	accounts.account_number as client_number,
    	accounts.title as client_name,
    	(select ifnull(sum(amount_charged),0) from billed_calls where bill_id = a.id) as calls_total_billed,
    	(select ifnull(sum(amount_charged),0) from billed_lines where bill_id = a.id) as lines_total_billed,
    	(select ifnull(sum(amount_charged),0) from billed_services where bill_id = a.id) as services_total_billed,
    	(select ifnull(sum(amount_charged),0) from billed_adjustments where bill_id = a.id) as adjustments_total_billed,
    	(select ifnull(sum(amount_charged),0) from billed_taxes where bill_id = a.id) as taxes_total_billed
    FROM bills as a INNER JOIN accounts ON a.account_id = accounts.id
    	 INNER JOIN billing_sessions ON a.billing_session_id = billing_sessions.id
    WHERE billing_session_id = " + billing_session.id.to_s + " and a.site_id = " + ActsAsTenant.current_tenant.id.to_s).each { |row| csv << row }
  end
  # billing_session = nil
  csv_string
end

def generate_summary_report(billing_session)
  require 'tempfile'
  csv_string = generate_summary_csv(billing_session)
  file = StringIO.new(csv_string)
  file.class.class_eval { attr_accessor :original_filename, :content_type } #add attributes
  file.original_filename = (billing_session.name).titleize.gsub(/ /,'') + "_Summary.csv"
  file.content_type = "application/csv"
  billing_session.csv = file
  billing_session.save!
  FileUtils.remove_dir("#{Rails.root}/public/uploads/tmp", :force => true)
  file = nil
  csv_string = nil
end
