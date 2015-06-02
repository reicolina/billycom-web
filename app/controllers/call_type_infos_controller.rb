class CallTypeInfosController < ApplicationController
  layout "application"
  # GET /call_type_infos
  # GET /call_type_infos.xml
  def index
    @call_type_infos = CallTypeInfo.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @call_type_infos }
    end
  end

  # GET /call_type_infos/new
  # GET /call_type_infos/new.xml
  def new
    @call_type_info = CallTypeInfo.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @call_type_info }
    end
  end

  # GET /call_type_infos/1/edit
  def edit
    @call_type_info = CallTypeInfo.find(params[:id])
  end

  # POST /call_type_infos
  # POST /call_type_infos.xml
  def create
    @call_type_info = CallTypeInfo.new(params[:call_type_info])

    respond_to do |format|
      if @call_type_info.save
        flash[:notice] = 'Call type was successfully created.'
        format.html { redirect_to(call_type_infos_url) }
        format.xml  { render :xml => @call_type_info, :status => :created, :location => @call_type_info }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @call_type_info.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /call_type_infos/1
  # PUT /call_type_infos/1.xml
  def update
    @call_type_info = CallTypeInfo.find(params[:id])

    respond_to do |format|
      if @call_type_info.update_attributes(params[:call_type_info])
        flash[:notice] = 'Call type was successfully updated.'
        format.html { redirect_to(call_type_infos_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @call_type_info.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /call_type_infos/1
  # DELETE /call_type_infos/1.xml
  def destroy
    @call_type_info = CallTypeInfo.find(params[:id])
    @call_type_info.destroy

    respond_to do |format|
      format.html { redirect_to(call_type_infos_url) }
      format.xml  { head :ok }
    end
  end
end
