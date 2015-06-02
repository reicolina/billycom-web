class AdjustmentsController < ApplicationController
  layout "application"
  # GET /adjustments
  # GET /adjustments.xml
  def index
    @account = Account.find(params[:account_id])
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @adjustments }
    end
  end

  # GET /adjustments/new
  # GET /adjustments/new.xml
  def new
    @account = Account.find(params[:account_id])
    @adjustment = @account.adjustments.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @adjustment }
    end
  end

  # GET /adjustments/1/edit
  def edit
    @account = Account.find(params[:account_id])
    @adjustment = @account.adjustments.find(params[:id])
  end

  # POST /adjustments
  # POST /adjustments.xml
  def create
    @account = Account.find(params[:account_id])
    @adjustment = @account.adjustments.new(params[:adjustment])

    respond_to do |format|
      if @adjustment.save
        flash[:notice] = 'Adjustment was successfully created.'
        format.html { redirect_to account_adjustments_url(:page => params[:page], :search_string => params[:search_string]) }
        format.xml  { render :xml => @adjustment, :status => :created, :location => @adjustment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @adjustment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /adjustments/1
  # PUT /adjustments/1.xml
  def update
    @account = Account.find(params[:account_id])
    @adjustment = @account.adjustments.find(params[:id])

    respond_to do |format|
      if @adjustment.update_attributes(params[:adjustment])
        flash[:notice] = 'Adjustment was successfully updated.'
        format.html { redirect_to account_adjustments_url(:page => params[:page], :search_string => params[:search_string]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @adjustment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /adjustments/1
  # DELETE /adjustments/1.xml
  def destroy
    @account = Account.find(params[:account_id])
    @adjustment = @account.adjustments.find(params[:id])
    @adjustment.destroy

    respond_to do |format|
      format.html { redirect_to :back }
      format.xml  { head :ok }
    end
  end
end
