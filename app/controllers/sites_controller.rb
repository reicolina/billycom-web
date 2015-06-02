class SitesController < ApplicationController
  before_filter :check_master, :only => [:new, :index, :create]
  skip_before_filter :require_user
  before_filter :require_user, :only => [:edit, :update, :show, :settings]
  layout "application"
  
  # GET /sites
  # GET /sites.xml
  def index
    @sites = Site.find(:all, :order => "name")
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sites }
    end
  end

  # GET /sites/1
  # GET /sites/1.xml
  def show
    @site = current_user.site
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @site }
    end
  end

  # GET /sites/new
  # GET /sites/new.xml
  def new
    @site = Site.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => sites_path }
    end
  end

  # GET /sites/1/edit
  def edit
    @site = current_user.site
  end

  # POST /sites
  # POST /sites.xml
  def create
    @site = Site.new(params[:site])
    
    respond_to do |format|
      if @site.save
        Rails.logger.info "SITE_CREATION_LOG: site created with ID of " + @site.id.to_s
        ActsAsTenant.with_tenant(@site) do
          populate_default_site(@site.id)
        end
        flash[:notice] =  @site.name + ' was successfully created.'
        format.html { redirect_to(sites_path) }
        format.xml  { render :xml => @site, :status => :created, :location => @site }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @site.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /sites/1
  # PUT /sites/1.xml
  def update
    @site = Site.find(params[:id])
    
    respond_to do |format|
      if @site.update_attributes(params[:site])
        flash[:notice] = @site.name + ' was successfully updated.'
        format.html { redirect_to(@site) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @site.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /sites/1
  # DELETE /sites/1.xml
  def destroy
    @site = Site.find(params[:id])
    @site.destroy
    
    respond_to do |format|
      format.html { redirect_to(sites_url) }
      format.xml  { head :ok }
    end
  end
  
  def delete_logo1
    @site = Site.find(params[:id])
    @site.logo = nil
    @site.logo_type = nil
    @site.logo_filename = nil
    @site.save
    respond_to do |format|
      format.html { redirect_to(@site) }
    end 
  end
  
  def bill_preview
    # Tested. This is multi-tenant friendly
    bill = Bill.find(:last)
    send_data BillsReport.new(:margin => 0).default_invoice(bill, Site.find(params[:id]), false), :filename => "SampleBill.pdf", :type => :pdf
    bill = nil
  end  
  
  def code_image 
    @site = Site.find(params[:id]) 
    @image = @site.logo 
    if (not @site.logo_type.nil?) && (not @site.logo_filename.nil?)
      send_data(@image, :type => @site.logo_type, :filename => @site.logo_filename, :disposition => 'inline')
    else
      send_data(nil)
    end
  end
  
  def settings
    @site = current_user.site
    respond_to do |format|
      format.html { redirect_to(@site) }
    end
  end
  
end
