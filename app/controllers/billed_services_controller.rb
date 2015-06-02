class BilledServicesController < ApplicationController
  layout "application"

  # GET /billed_services
  # GET /billed_services.xml
  def index
    @bill = Bill.find(params[:bill_id])
    #@billed_services = BilledService.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @billed_services }
    end
  end

  # GET /billed_services/new
  # GET /billed_services/new.xml
  def new
    @bill = Bill.find(params[:bill_id])
    @billed_service = @bill.billed_services.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @billed_service }
    end
  end

  # GET /billed_services/1/edit
  def edit
    @bill = Bill.find(params[:bill_id])
    @billed_service = @bill.billed_services.find(params[:id])
  end

  # POST /billed_services
  # POST /billed_services.xml
  def create
    @bill = Bill.find(params[:bill_id])
    @billed_service = @bill.billed_services.new(params[:billed_service])

    respond_to do |format|
      if @billed_service.save
        @bill.billed_taxes.each do |billed_tax|
          billed_tax.recalculate
        end
        #We have to save the flag here, other wise it woun't reflect when the landing page is loaded
        @bill.pending_flag = true
        @bill.save
        call_rake :regenerate_bill, :bill_id => params[:bill_id]
        flash[:notice] = 'Bill is being re-generated.'
        format.html { redirect_to(billing_session_bills_url(@bill.billing_session) + "?page=" + params[:page].to_s) }
        format.xml  { render :xml => @billed_service, :status => :created, :location => @billed_service }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @billed_service.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /billed_services/1
  # PUT /billed_services/1.xml
  def update
    @bill = Bill.find(params[:bill_id])
    @billed_service = @bill.billed_services.find(params[:id])

    respond_to do |format|
      if @billed_service.update_attributes(params[:billed_service])
        @bill.billed_taxes.each do |billed_tax|
          billed_tax.recalculate
        end
        #We have to save the flag here, other wise it woun't reflect when the landing page is loaded
        @bill.pending_flag = true
        @bill.save
        call_rake :regenerate_bill, :bill_id => params[:bill_id]
        flash[:notice] = 'Bill is being re-generated.'
        format.html { redirect_to(billing_session_bills_url(@bill.billing_session) + "?page=" + params[:page].to_s) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @billed_service.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /billed_services/1
  # DELETE /billed_services/1.xml
  def destroy
    @bill = Bill.find(params[:bill_id])
    @billed_service = @bill.billed_services.find(params[:id])
    @billed_service.destroy
    
    @bill.billed_taxes.each do |billed_tax|
      billed_tax.recalculate
    end
    #We have to save the flag here, other wise it woun't reflect when the landing page is loaded
    @bill.pending_flag = true
    @bill.save
    call_rake :regenerate_bill, :bill_id => params[:bill_id]
    flash[:notice] = 'Bill is being re-generated.'

    respond_to do |format|
      format.html { redirect_to :back }
      format.xml  { head :ok }
    end
  end
end
