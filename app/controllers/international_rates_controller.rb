class InternationalRatesController < ApplicationController
  layout "application"
  # GET /international_rates
  # GET /international_rates.xml
  
  def index
    @international_rates = InternationalRate.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @international_rates }
    end
  end

  # GET /international_rates/1
  # GET /international_rates/1.xml
  def show
    @international_rate = InternationalRate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @international_rate }
    end
  end

  # GET /international_rates/new
  # GET /international_rates/new.xml
  def new
    @international_rate = InternationalRate.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @international_rate }
    end
  end

  # GET /international_rates/1/edit
  def edit
    @call_type_info = CallTypeInfo.new #Ths looks dirty but it needs to be here so we can use the CallTypeInfo constants
    @international_rate = InternationalRate.find(params[:id])
  end

  # POST /international_rates
  # POST /international_rates.xml
  def create
    @international_rate = InternationalRate.new(params[:international_rate])

    respond_to do |format|
      if @international_rate.save
        flash[:notice] = 'International rate was successfully created.'
        format.html { redirect_to(@international_rate.international_plan) }
        format.xml  { render :xml => @international_rate, :status => :created, :location => @international_rate }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @international_rate.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /international_rates/1
  # PUT /international_rates/1.xml
  def update
    @international_rate = InternationalRate.find(params[:id])

    respond_to do |format|
      if @international_rate.update_attributes(params[:international_rate])
        flash[:notice] = 'International rate was successfully updated.'
        format.html { redirect_to polymorphic_path(@international_rate.international_plan, :page => params[:page]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @international_rate.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /international_rates/1
  # DELETE /international_rates/1.xml
  def destroy
    @international_rate = InternationalRate.find(params[:id])
    @international_rate.destroy

    respond_to do |format|
      format.html { redirect_to :back }
      format.xml  { head :ok }
    end
  end
end
