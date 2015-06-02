class Bill < ActiveRecord::Base
  acts_as_tenant(:site)
  mount_uploader :pdf, FileUploader
  mount_uploader :csv, FileUploader
  # attr_accessible :name, :rate
  belongs_to :site
  belongs_to :billing_session
  belongs_to :account
  has_many :billed_calls, :dependent => :destroy
  has_many :billed_lines, :dependent => :destroy,:order => '`type_of_line`, `use`, `number`'
  has_many :billed_services, :dependent => :destroy
  has_many :billed_taxes, :dependent => :destroy
  has_many :billed_adjustments, :dependent => :destroy

end

def generate_bill_files(bill)
  require 'tempfile'
  require 'csv'
  Rails.logger.info "BILLING_LOG: generating bill files for bill id: " +  bill.id.to_s + " and company: " + ActsAsTenant.current_tenant.name.to_s + "(" + ActsAsTenant.current_tenant.id.to_s + ")"
  # if bill.pending_flag == false
  #   bill.pending_flag = true
  #   # bill.save
  # end
  if bill.billed_calls.count < Source::Application.config.max_amount_of_records_per_bill
    Rails.logger.info "BILLING_LOG: generating PDF for bill id: " +  bill.id.to_s + " and company: " + ActsAsTenant.current_tenant.name.to_s + "(" + ActsAsTenant.current_tenant.id.to_s + ")"
    file = StringIO.new(BillsReport.new(:margin => 0).default_invoice(bill, bill.site, false))
    file.class.class_eval { attr_accessor :original_filename, :content_type } #add attributes
    file.original_filename = (bill.account.title + bill.billing_session.name).titleize.gsub(/ /,'') + ".pdf"
    file.content_type = "application/pdf"
    bill.pdf = file
    Rails.logger.info "MEMORY_MANAGEMENT: [generate_bill_files - pdf] starting garbage collector"
    GC.start #force garbage collector
  end
  Rails.logger.info "BILLING_LOG: generating CSV for bill id: " +  bill.id.to_s + " and company: " + ActsAsTenant.current_tenant.name.to_s + "(" + ActsAsTenant.current_tenant.id.to_s + ")"
  csv_string = CSV.generate do |csv| 
    csv << ["Originating_Number","Call_Date","Call_Time","Duration_sec","Destination","Destination_Province_State","Destination_Number","Account_Code","Charge_$","Call_Type"]
    BilledCall.where("bill_id = " + bill.id.to_s).find_each do |call|
      csv << [call.orig_tn, call.date, call.time, call.duration_sec, call.destination, call.dest_prov_state, call.term_tn, call.code, call.amount_charged, call.call_type]
    end
    Rails.logger.info "MEMORY_MANAGEMENT: [generate_bill_files - csv] starting garbage collector"
    GC.start #force garbage collector
  end
  file = StringIO.new(csv_string)
  file.class.class_eval { attr_accessor :original_filename, :content_type } #add attributes
  file.original_filename = (bill.account.title + bill.billing_session.name).titleize.gsub(/ /,'') + ".csv"
  file.content_type = "application/csv"
  bill.csv = file
  bill.pending_flag = false
  bill.save!
  FileUtils.remove_dir("#{Rails.root}/public/uploads/tmp", :force => true)
  Rails.logger.info "BILLING_LOG: finished generating bill files for bill id: " +  bill.id.to_s + " and company: " + ActsAsTenant.current_tenant.name.to_s + "(" + ActsAsTenant.current_tenant.id.to_s + ")"
  file = nil
  csv_string = nil
  call = nil
  csv = nil
  uploader = nil
end