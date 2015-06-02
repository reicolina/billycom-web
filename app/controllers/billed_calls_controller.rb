class BilledCallsController < ApplicationController
  layout "application"

  # GET /billed_calls
  # GET /billed_calls.xml
  def index
    @bill = Bill.find(params[:bill_id])
    @billed_calls = Kaminari.paginate_array(@bill.billed_calls).page(params[:subpage]).per(Source::Application.config.items_per_page)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @billed_calls }
    end
  end

  # GET /billed_calls/new
  # GET /billed_calls/new.xml
  def new
    @bill = Bill.find(params[:bill_id])
    @billed_call = @bill.billed_calls.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @billed_call }
    end
  end

  # GET /billed_calls/1/edit
  def edit
    @bill = Bill.find(params[:bill_id])
    @billed_call = @bill.billed_calls.find(params[:id])
  end

  # POST /billed_calls
  # POST /billed_calls.xml
  def create
    @bill = Bill.find(params[:bill_id])
    @billed_call = @bill.billed_calls.new(params[:billed_call])

    respond_to do |format|
      if @billed_call.save
        @bill.billed_taxes.each do |billed_tax|
          billed_tax.recalculate
        end
        #We have to save the flag here, other wise it woun't reflect when the landing page is loaded
        @bill.pending_flag = true
        @bill.save
        call_rake :regenerate_bill, :bill_id => params[:bill_id]
        flash[:notice] = 'Bill is being re-generated.'
        format.html { redirect_to(billing_session_bills_url(@bill.billing_session) + "?page=" + params[:page].to_s) }
        format.xml  { render :xml => @billed_call, :status => :created, :location => @billed_call }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @billed_call.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /billed_calls/1
  # PUT /billed_calls/1.xml
  def update
    @bill = Bill.find(params[:bill_id])
    @billed_call = @bill.billed_calls.find(params[:id])

    respond_to do |format|
      if @billed_call.update_attributes(params[:billed_call])
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
        format.xml  { render :xml => @billed_call.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /billed_calls/1
  # DELETE /billed_calls/1.xml
  def destroy
    @bill = Bill.find(params[:bill_id])
    @billed_call = @bill.billed_calls.find(params[:id])
    @billed_call.destroy
    
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
