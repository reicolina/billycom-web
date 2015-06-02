class BilledAdjustmentsController < ApplicationController
  layout "application"

  # GET /billed_adjustments
  # GET /billed_adjustments.xml
  def index
    @bill = Bill.find(params[:bill_id])
    #@billed_adjustments = BilledAdjustment.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @billed_adjustments }
    end
  end

  # GET /billed_adjustments/new
  # GET /billed_adjustments/new.xml
  def new
    @bill = Bill.find(params[:bill_id])
    @billed_adjustment = @bill.billed_adjustments.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @billed_adjustment }
    end
  end

  # GET /billed_adjustments/1/edit
  def edit
    @bill = Bill.find(params[:bill_id])
    @billed_adjustment = @bill.billed_adjustments.find(params[:id])
  end

  # POST /billed_adjustments
  # POST /billed_adjustments.xml
  def create
    @bill = Bill.find(params[:bill_id])
    @billed_adjustment = @bill.billed_adjustments.new(params[:billed_adjustment])

    respond_to do |format|
      if @billed_adjustment.save
        @bill.billed_taxes.each do |billed_tax|
          billed_tax.recalculate
        end
        #We have to save the flag here, other wise it woun't reflect when the landing page is loaded
        @bill.pending_flag = true
        @bill.save
        call_rake :regenerate_bill, :bill_id => params[:bill_id]
        flash[:notice] = 'Bill is being re-generated.'
        format.html { redirect_to(billing_session_bills_url(@bill.billing_session) + "?page=" + params[:page].to_s) }
        format.xml  { render :xml => @billed_adjustment, :status => :created, :location => @billed_adjustment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @billed_adjustment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /billed_adjustments/1
  # PUT /billed_adjustments/1.xml
  def update
    @bill = Bill.find(params[:bill_id])
    @billed_adjustment = @bill.billed_adjustments.find(params[:id])

    respond_to do |format|
      if @billed_adjustment.update_attributes(params[:billed_adjustment])
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
        format.xml  { render :xml => @billed_adjustment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /billed_adjustments/1
  # DELETE /billed_adjustments/1.xml
  def destroy
    @bill = Bill.find(params[:bill_id])
    @billed_adjustment = @bill.billed_adjustments.find(params[:id])
    @billed_adjustment.destroy
    
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
