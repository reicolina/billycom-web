class RatingPlansController < ApplicationController
  layout "application"
  # GET /rating_plans
  # GET /rating_plans.xml
  def index
    @rating_plans = RatingPlan.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @rating_plans }
    end
  end

  # GET /rating_plans/new
  # GET /rating_plans/new.xml
  def new
    @rating_plan = RatingPlan.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @rating_plan }
    end
  end

  # GET /rating_plans/1/edit
  def edit
    @rating_plan = RatingPlan.find(params[:id])
  end

  # POST /rating_plans
  # POST /rating_plans.xml
  def create
    @rating_plan = RatingPlan.new(params[:rating_plan])

    respond_to do |format|
      if @rating_plan.save
        flash[:notice] = 'Long distance plan was successfully created.'
        format.html { redirect_to(rating_plans_url) }
        format.xml  { render :xml => @rating_plan, :status => :created, :location => @rating_plan }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @rating_plan.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /rating_plans/1
  # PUT /rating_plans/1.xml
  def update
    @rating_plan = RatingPlan.find(params[:id])

    respond_to do |format|
      if @rating_plan.update_attributes(params[:rating_plan])
        flash[:notice] = 'Long distance plan was successfully updated.'
        format.html { redirect_to(rating_plans_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @rating_plan.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /rating_plans/1
  # DELETE /rating_plans/1.xml
  def destroy
    @rating_plan = RatingPlan.find(params[:id])
    if @rating_plan.destroy then
      respond_to do |format|
        format.html { redirect_to(rating_plans_url) }
        format.xml  { head :ok }
      end      
    else
      render :action => :edit
    end
  end
end
