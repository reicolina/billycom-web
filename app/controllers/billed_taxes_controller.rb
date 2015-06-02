class BilledTaxesController < ApplicationController
  layout "application"

  # GET /billed_taxes
  # GET /billed_taxes.xml
  def index
    @bill = Bill.find(params[:bill_id])
    #@billed_taxes = BilledTax.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @billed_taxes }
    end
  end

  # GET /billed_taxes/new
  # GET /billed_taxes/new.xml
  def new
    @bill = Bill.find(params[:bill_id])
    @billed_tax = @bill.billed_taxes.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @billed_tax }
    end
  end

  # GET /billed_taxes/1/edit
  def edit
    @bill = Bill.find(params[:bill_id])
    @billed_tax = @bill.billed_taxes.find(params[:id])
  end

  # POST /billed_taxes
  # POST /billed_taxes.xml
  def create
    @bill = Bill.find(params[:bill_id])
    @billed_tax = @bill.billed_taxes.new(params[:billed_tax])

    respond_to do |format|
      if @billed_tax.save
        @bill.billed_taxes.each do |billed_tax|
          billed_tax.recalculate
        end
        #We have to save the flag here, other wise it woun't reflect when the landing page is loaded
        @bill.pending_flag = true
        @bill.save
        call_rake :regenerate_bill, :bill_id => params[:bill_id]
        flash[:notice] = 'Bill is being re-generated.'
        format.html { redirect_to(billing_session_bills_url(@bill.billing_session) + "?page=" + params[:page].to_s) }
        format.xml  { render :xml => @billed_tax, :status => :created, :location => @billed_tax }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @billed_tax.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /billed_taxes/1
  # PUT /billed_taxes/1.xml
  def update
    @bill = Bill.find(params[:bill_id])
    @billed_tax = @bill.billed_taxes.find(params[:id])

    respond_to do |format|
      if @billed_tax.update_attributes(params[:billed_tax])
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
        format.xml  { render :xml => @billed_tax.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /billed_taxes/1
  # DELETE /billed_taxes/1.xml
  def destroy
    @bill = Bill.find(params[:bill_id])
    @billed_tax = @bill.billed_taxes.find(params[:id])
    @billed_tax.destroy
    
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
