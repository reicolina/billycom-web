class TaxesController < ApplicationController
  layout "application"
  # GET /taxes
  # GET /taxes.xml
  def index
    @taxes = Tax.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @taxes }
    end
  end

  # GET /taxes/new
  # GET /taxes/new.xml
  def new
    @tax = Tax.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tax }
    end
  end

  # GET /taxes/1/edit
  def edit
    @tax = Tax.find(params[:id])
  end

  # POST /taxes
  # POST /taxes.xml
  def create
    @tax = Tax.new(params[:tax])

    respond_to do |format|
      if @tax.save
        if params[:assign_to_all] == "1"
          @tax.assign_to_all_clients
          flash[:notice] = 'Tax was successfully created and added to all clients.'
        else
          flash[:notice] = 'Tax was successfully created.'
        end
        format.html { redirect_to(taxes_url) }
        format.xml  { render :xml => @tax, :status => :created, :location => @tax }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tax.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /taxes/1
  # PUT /taxes/1.xml
  def update
    @tax = Tax.find(params[:id])

    respond_to do |format|
      if @tax.update_attributes(params[:tax])
        flash[:notice] = 'Tax was successfully updated.'
        format.html { redirect_to(taxes_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tax.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /taxes/1
  # DELETE /taxes/1.xml
  def destroy
    @tax = Tax.find(params[:id])
    @tax.destroy

    respond_to do |format|
      format.html { redirect_to(taxes_url) }
      format.xml  { head :ok }
    end
  end
end
