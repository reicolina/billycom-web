class LocalPlansController < ApplicationController
  layout "application"
  # GET /local_plans
  # GET /local_plans.xml
  def index
    @local_plans = LocalPlan.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @local_plans }
    end
  end

  # GET /local_plans/new
  # GET /local_plans/new.xml
  def new
    @local_plan = LocalPlan.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @local_plan }
    end
  end

  # GET /local_plans/1/edit
  def edit
    @local_plan = LocalPlan.find(params[:id])
  end

  # POST /local_plans
  # POST /local_plans.xml
  def create
    @local_plan = LocalPlan.new(params[:local_plan])

    respond_to do |format|
      if @local_plan.save
        flash[:notice] = 'Local rate was successfully created.'
        format.html { redirect_to(local_plans_url) }
        format.xml  { render :xml => @local_plan, :status => :created, :location => @local_plan }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @local_plan.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /local_plans/1
  # PUT /local_plans/1.xml
  def update
    @local_plan = LocalPlan.find(params[:id])

    respond_to do |format|
      if @local_plan.update_attributes(params[:local_plan])
        flash[:notice] = 'Local rate was successfully updated.'
        format.html { redirect_to(local_plans_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @local_plan.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /local_plans/1
  # DELETE /local_plans/1.xml
  def destroy
    @local_plan = LocalPlan.find(params[:id])
    if @local_plan.destroy then
      respond_to do |format|
        format.html { redirect_to(local_plans_url) }
        format.xml  { head :ok }
      end      
    else
      render :action => :edit
    end
  end
  
end
