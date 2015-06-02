class BillingSessionsController < ApplicationController
  layout "application"
  
  def batch_email
    Rails.logger.info "EMAIL_LOG: Starting Batched emailing."
    @billing_session = BillingSession.find(params[:id])
    Rails.logger.info "EMAIL_LOG: Billing Session ID: " + @billing_session.id.to_s
    @billing_session.batch_email_status = BillingSession::EMAILS_IN_PROGRESS
    Rails.logger.info "EMAIL_LOG: Billing Session eail status: " + @billing_session.batch_email_status.to_s
    if @billing_session.save
      @billing_session.batch_email_process(@billing_session.id)
      # call_rake :batch_emailing, :billing_session_id => params[:id]
      respond_to do |format|
        flash[:notice] = 'Bills are being delivered'
        format.html { redirect_to(@billing_session) }
        format.xml  { head :ok }
      end
    else
      flash[:notice] = 'Could not deliver bills by email'
      format.html { redirect_to(@billing_session) }
      format.xml  { head :ok }
    end

  end
  
  # def export_csv
  #   billing_session = BillingSession.find(params[:id])
  #   # send_data generate_summary_csv(billing_session), :type => "text/csv", :filename => (billing_session.name + "_Summary").titleize.gsub(/ /,'') + ".csv"
  #   send_data billing_session.csv.read,  :filename => billing_session.csv.file.filename, :type => "text/csv"
  #   billing_session = nil
  # end
  
  # GET /billing_sessions
  # GET /billing_sessions.xml
  def index
    @billing_sessions = BillingSession.all(:order => 'billing_date DESC')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @billing_sessions }
    end
  end

  # GET /billing_sessions/1
  # GET /billing_sessions/1.xml
  def show
    @billing_session = BillingSession.find(params[:id], :include => [:bills, {:bills => :account}])
    @site = ActsAsTenant.current_tenant
    @email_count = 0
    @billing_session.bills.each do |bill|
      if not bill.account.billing_email.nil?
        if not bill.pdf.nil?
          if bill.account.billing_email.length > 0 and not bill.pdf.length > Source::Application.config.email_attachment_max_size
            @email_count = @email_count + 1
            break
          end
        end
      end
    end
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @billing_session }
    end
  end

  # GET /billing_sessions/new
  # GET /billing_sessions/new.xml
  def new
    @billing_session = BillingSession.new
    max_id = BillingSession.maximum(:id)
    if max_id.nil?
      @billing_session.start_number = 1
    else 
      max_bill_id =  Bill.maximum(:number, :conditions => 'billing_session_id = ' + max_id.to_s + ' and number is not null')
      if not max_bill_id.nil?
        @billing_session.start_number = Bill.maximum(:number, :conditions => 'billing_session_id = ' + max_id.to_s) + 1
      else
        @billing_session.start_number = 1
      end
    end
    max_id = nil

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @billing_session }
    end
  end

  # GET /billing_sessions/1/edit
  def edit
    @billing_session = BillingSession.find(params[:id])
  end

  # POST /billing_sessions
  # POST /billing_sessions.xml
  def create
    @billing_session = BillingSession.new(params[:billing_session])   
    @billing_session.call_detail_records = CallDetailRecord.find(params[:call_detail_record_ids]) if params[:call_detail_record_ids]
    @billing_session.pending_flag = true
        
    respond_to do |format|
      if @billing_session.save
        TempCall.update_all( "billing_session_id = " + @billing_session.id.to_s, "billing_session_id is null" )
        logger.debug "DEBUG: Calling `run_billing` rake for: " +  ActsAsTenant.current_tenant.name.to_s + "(" + ActsAsTenant.current_tenant.id.to_s + ")"
        @billing_session.do_billing(@billing_session.id)
        flash[:notice] = 'Billing process has successfully started.'
        format.html { redirect_to(billing_sessions_url) }
        format.xml  { render :xml => @billing_session, :status => :created, :location => @billing_session }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @billing_session.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /billing_sessions/1
  # PUT /billing_sessions/1.xml
  def update
    @billing_session = BillingSession.find(params[:id])

    respond_to do |format|
      if @billing_session.update_attributes(params[:billing_session])
        flash[:notice] = 'BillingSession was successfully updated.'
        format.html { redirect_to(@billing_session) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @billing_session.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /billing_sessions/1
  # DELETE /billing_sessions/1.xml
  def destroy
    @billing_session = BillingSession.find(params[:id])
    @billing_session.connection.execute('delete from billed_calls where bill_id in (select id from bills where billing_session_id = ' + @billing_session.id.to_s + " and `site_id` = " + ActsAsTenant.current_tenant.id.to_s + ')' + " and `site_id` = " + ActsAsTenant.current_tenant.id.to_s)
    @billing_session.connection.execute('delete from billed_lines where bill_id in (select id from bills where billing_session_id = ' + @billing_session.id.to_s + " and `site_id` = " + ActsAsTenant.current_tenant.id.to_s + ')' + " and `site_id` = " + ActsAsTenant.current_tenant.id.to_s)
    @billing_session.connection.execute('delete from billed_services where bill_id in (select id from bills where billing_session_id = ' + @billing_session.id.to_s + " and `site_id` = " + ActsAsTenant.current_tenant.id.to_s + ')' + " and `site_id` = " + ActsAsTenant.current_tenant.id.to_s)
    @billing_session.connection.execute('delete from billed_taxes where bill_id in (select id from bills where billing_session_id = ' + @billing_session.id.to_s + " and `site_id` = " + ActsAsTenant.current_tenant.id.to_s + ')' + " and `site_id` = " + ActsAsTenant.current_tenant.id.to_s)
    @billing_session.connection.execute('delete from billed_adjustments where bill_id in (select id from bills where billing_session_id = ' + @billing_session.id.to_s + " and `site_id` = " + ActsAsTenant.current_tenant.id.to_s + ')' + " and `site_id` = " + ActsAsTenant.current_tenant.id.to_s)
    # @billing_session.connection.execute('delete from bills where billing_session_id = ' + @billing_session.id.to_s + " and `site_id` = " + ActsAsTenant.current_tenant.id.to_s)

    @billing_session.destroy

    respond_to do |format|
      format.html { redirect_to(billing_sessions_url) }
      format.xml  { head :ok }
    end
  end
end
