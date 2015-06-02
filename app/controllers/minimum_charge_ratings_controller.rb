class MinimumChargeRatingsController < ApplicationController
  layout "application"
  # GET /minimum_charge_ratings
  # GET /minimum_charge_ratings.xml
  def index
    @minimum_charge_ratings = MinimumChargeRating.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @minimum_charge_ratings }
    end
  end

  # GET /minimum_charge_ratings/new
  # GET /minimum_charge_ratings/new.xml
  def new
    @minimum_charge_rating = MinimumChargeRating.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @minimum_charge_rating }
    end
  end

  # GET /minimum_charge_ratings/1/edit
  def edit
    @minimum_charge_rating = MinimumChargeRating.find(params[:id])
  end

  # POST /minimum_charge_ratings
  # POST /minimum_charge_ratings.xml
  def create
    @minimum_charge_rating = MinimumChargeRating.new(params[:minimum_charge_rating])

    respond_to do |format|
      if @minimum_charge_rating.save
        flash[:notice] = 'Minimum charge was successfully created.'
        format.html { redirect_to(minimum_charge_ratings_url) }
        format.xml  { render :xml => @minimum_charge_rating, :status => :created, :location => @minimum_charge_rating }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @minimum_charge_rating.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /minimum_charge_ratings/1
  # PUT /minimum_charge_ratings/1.xml
  def update
    @minimum_charge_rating = MinimumChargeRating.find(params[:id])

    respond_to do |format|
      if @minimum_charge_rating.update_attributes(params[:minimum_charge_rating])
        flash[:notice] = 'Minimum charge was successfully updated.'
        format.html { redirect_to(minimum_charge_ratings_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @minimum_charge_rating.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /minimum_charge_ratings/1
  # DELETE /minimum_charge_ratings/1.xml
  def destroy
    @minimum_charge_rating = MinimumChargeRating.find(params[:id])
    if @minimum_charge_rating.destroy then
      respond_to do |format|
        format.html { redirect_to(minimum_charge_ratings_url) }
        format.xml  { head :ok }
      end      
    else
      render :action => :edit
    end
  end
end
