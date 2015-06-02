class BilledLinesController < ApplicationController
  layout "application"

  # GET /billed_lines
  # GET /billed_lines.xml
  def index
    @bill = Bill.find(params[:bill_id])
    # @billed_lines = BilledLine.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @billed_lines }
    end
  end

  # GET /billed_lines/new
  # GET /billed_lines/new.xml
  def new
    @bill = Bill.find(params[:bill_id])
    @billed_line = @bill.billed_lines.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @billed_line }
    end
  end

  # GET /billed_lines/1/edit
  def edit
    @bill = Bill.find(params[:bill_id])
    @billed_line = @bill.billed_lines.find(params[:id])
  end

  # POST /billed_lines
  # POST /billed_lines.xml
  def create
    @bill = Bill.find(params[:bill_id])
    @billed_line = @bill.billed_lines.new(params[:billed_line])

    respond_to do |format|
      if @billed_line.save
        @bill.billed_taxes.each do |billed_tax|
          billed_tax.recalculate
        end
        #We have to save the flag here, other wise it woun't reflect when the landing page is loaded
        @bill.pending_flag = true
        @bill.save
        call_rake :regenerate_bill, :bill_id => params[:bill_id]
        flash[:notice] = 'Bill is being re-generated.'
        format.html { redirect_to(billing_session_bills_url(@bill.billing_session) + "?page=" + params[:page].to_s) }
        format.xml  { render :xml => @billed_line, :status => :created, :location => @billed_line }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @billed_line.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /billed_lines/1
  # PUT /billed_lines/1.xml
  def update
    @bill = Bill.find(params[:bill_id])
    @billed_line = @bill.billed_lines.find(params[:id])
    respond_to do |format|
      if @billed_line.update_attributes(params[:billed_line])
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
        format.xml  { render :xml => @billed_line.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /billed_lines/1
  # DELETE /billed_lines/1.xml
  def destroy
    @bill = Bill.find(params[:bill_id])
    @billed_line = @bill.billed_lines.find(params[:id])
    @billed_line.destroy
    
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
