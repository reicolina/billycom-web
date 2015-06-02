class SalesRepsController < ApplicationController
  layout "application"

  # GET /sales_reps
  # GET /sales_reps.xml
  def index
    @sales_reps = SalesRep.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sales_reps }
    end
  end

  # GET /sales_reps/new
  # GET /sales_reps/new.xml
  def new
    @sales_rep = SalesRep.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @sales_rep }
    end
  end

  # GET /sales_reps/1/edit
  def edit
    @sales_rep = SalesRep.find(params[:id])
  end

  # POST /sales_reps
  # POST /sales_reps.xml
  def create
    @sales_rep = SalesRep.new(params[:sales_rep])

    respond_to do |format|
      if @sales_rep.save
        flash[:notice] = 'SalesRep was successfully created.'
        format.html { redirect_to(sales_reps_url) }
        format.xml  { render :xml => @sales_rep, :status => :created, :location => @sales_rep }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @sales_rep.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /sales_reps/1
  # PUT /sales_reps/1.xml
  def update
    @sales_rep = SalesRep.find(params[:id])

    respond_to do |format|
      if @sales_rep.update_attributes(params[:sales_rep])
        flash[:notice] = 'SalesRep was successfully updated.'
        format.html { redirect_to(sales_reps_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @sales_rep.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /sales_reps/1
  # DELETE /sales_reps/1.xml
  def destroy
    @sales_rep = SalesRep.find(params[:id])
    if @sales_rep.destroy then
      respond_to do |format|
        format.html { redirect_to(sales_reps_url) }
        format.xml  { head :ok }
      end      
    else
      render :action => :edit
    end
  end
end
