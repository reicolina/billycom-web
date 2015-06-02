class BillsController < ApplicationController
  layout "application"
  
  require 'prawn'
  require 'csv'
  
  def email_invoice
    bill = Bill.find(params[:id], :include => [:account])
    BillMailer.invoice_email(bill.account.billing_email, bill, ActsAsTenant.current_tenant).deliver
    respond_to do |format|
      bill.emailed = true
      bill.save
      flash[:notice] = 'Bill was successfully emailed to: ' + bill.account.billing_email
      format.html { redirect_to(billing_session_bills_url(bill.billing_session.id)) }
    end
    bill = nil
  end
  
  # def get_invoice
  #   bill = Bill.find(params[:id])
  #   # send_data bill.pdf, :filename => (bill.account.title + bill.billing_session.name).titleize.gsub(/ /,'') + ".pdf", :type => :pdf
  #   send_data bill.pdf.read,  :filename => bill.pdf.file.filename, :type => :pdf
  #   bill = nil
  # end
  
  # def export_csv
  #   bill = Bill.find(params[:id])
  #   # send_data bill.csv, :type => "text/csv", :filename => (bill.account.title + bill.billing_session.name).titleize.gsub(/ /,'') + ".csv"
  #   send_data bill.csv.read, :type => "text/csv", :filename => bill.csv.file.filename
  #   bill = nil
  # end
  
  # GET /bills
  # GET /bills.xml
  def index
    @site = ActsAsTenant.current_tenant
    @billing_session = BillingSession.find(params[:billing_session_id], :include => [:bills, {:bills => :account}])
    @bills = Kaminari.paginate_array(@billing_session.bills).page(params[:page]).per(Source::Application.config.items_per_page)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @bills }
    end
  end

  # GET /bills/1
  # GET /bills/1.xml
  def show
    @billing_session = BillingSession.find(params[:billing_session_id])
    @bill = @billing_session.bills.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bill }
    end
  end

  # GET /bills/new
  # GET /bills/new.xml
  def new
    @billing_session = BillingSession.find(params[:billing_session_id])
    @bill = @billing_session.bills.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bill }
    end
  end

  # GET /bills/1/edit
  def edit
    @billing_session = BillingSession.find(params[:billing_session_id])
    @bill = @billing_session.bills.find(params[:id])
  end

  # POST /bills
  # POST /bills.xml
  def create
    @billing_session = BillingSession.find(params[:billing_session_id])
    @bill = @billing_session.bills.new(params[:bill])

    respond_to do |format|
      if @bill.save
        flash[:notice] = 'Bill was successfully created.'
        format.html { redirect_to(billing_session_lines_url) }
        format.xml  { render :xml => @bill, :status => :created, :location => @bill }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @bill.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /bills/1
  # PUT /bills/1.xml
  def update
    @billing_session = BillingSession.find(params[:billing_session_id])
    @bill = @billing_session.bills.find(params[:id])

    respond_to do |format|
      if @bill.update_attributes(params[:bill])
        flash[:notice] = 'Bill was successfully updated.'
        format.html { redirect_to(billing_session_bills_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @bill.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /bills/1
  # DELETE /bills/1.xml
  def destroy
    @billing_session = BillingSession.find(params[:billing_session_id])
    @bill = @billing_session.bills.find(params[:id])
    @bill.destroy

    respond_to do |format|
      format.html { redirect_to(billing_session_bills_url) }
      format.xml  { head :ok }
    end
  end
end
