class InternationalPlansController < ApplicationController
  layout "application"
  
  require 'csv'

  def import
    InternationalRate.destroy_all(:international_plan_id => params[:id])
    data = params[:dump][:file].read
    parsed_file=CSV.parse(data)
    n=InternationalRate.import_rates(parsed_file, params[:id])
    flash[:notice] = "CSV Import Successful,  #{n} new records added to data base"
    respond_to do |format|
       format.html { redirect_to(international_plan_url) }
    end
  end
  
  # GET /international_plans
  # GET /international_plans.xml  
  def index
    @international_plans = InternationalPlan.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @international_plans }
    end
  end

  # GET /international_plans/1
  # GET /international_plans/1.xml
  def show
    @international_plan = InternationalPlan.find(params[:id])
    @rates = @international_plan.international_rates.order(:destination).page(params[:page])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @international_plan }
    end
  end

  # GET /international_plans/new
  # GET /international_plans/new.xml
  def new
    @international_plan = InternationalPlan.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @international_plan }
    end
  end

  # GET /international_plans/1/edit
  def edit
    @international_plan = InternationalPlan.find(params[:id])
  end

  # POST /international_plans
  # POST /international_plans.xml
  def create
    @international_plan = InternationalPlan.new(params[:international_plan])

    respond_to do |format|
      if @international_plan.save
        flash[:notice] = 'International plan was successfully created.'
        format.html { redirect_to(@international_plan) }
        format.xml  { render :xml => @international_plan, :status => :created, :location => @international_plan }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @international_plan.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /international_plans/1
  # PUT /international_plans/1.xml
  def update
    @international_plan = InternationalPlan.find(params[:id])

    respond_to do |format|
      if @international_plan.update_attributes(params[:international_plan])
        flash[:notice] = 'International plan was successfully updated.'
        format.html { redirect_to(international_plans_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @international_plan.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /international_plans/1
  # DELETE /international_plans/1.xml
  def destroy
    @international_plan = InternationalPlan.find(params[:id])
    if @international_plan.destroy then
      respond_to do |format|
        format.html { redirect_to(international_plans_url) }
        format.xml  { head :ok }
      end      
    else
      render :action => :edit
    end
  end
  
end
