class OtherServicesController < ApplicationController
  layout "application"

  def index
    @account = Account.find(params[:account_id])
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @other_services }
    end
  end

  def new
    @account = Account.find(params[:account_id])
    @other_service = @account.other_services.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @other_service }
    end
  end

  def edit
    @account = Account.find(params[:account_id])
    @other_service = @account.other_services.find(params[:id])
  end

  def create
    @account = Account.find(params[:account_id])
    @other_service = @account.other_services.new(params[:other_service])

    respond_to do |format|
      if @other_service.save
        flash[:notice] = 'Service was successfully created.'
        format.html { redirect_to account_other_services_url(:page => params[:page], :search_string => params[:search_string]) }
        format.xml  { render :xml => @other_service, :status => :created, :location => @other_service }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @other_service.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def update
    @account = Account.find(params[:account_id])
    @other_service = @account.other_services.find(params[:id])

    respond_to do |format|
      if @other_service.update_attributes(params[:other_service])
        flash[:notice] = 'Service was successfully updated.'
        format.html { redirect_to account_other_services_url(:page => params[:page], :search_string => params[:search_string]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @other_service.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @account = Account.find(params[:account_id])
    @other_service = @account.other_services.find(params[:id])
    @other_service.destroy

    respond_to do |format|
      format.html { redirect_to :back }
      format.xml  { head :ok }
    end
  end
end
