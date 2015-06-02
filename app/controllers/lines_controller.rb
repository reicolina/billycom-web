class LinesController < ApplicationController
  layout "application"
  # GET /lines
  # GET /lines.xml
  def index
    @account = Account.find(params[:account_id])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @lines }
    end
  end

  # GET /lines/new
  # GET /lines/new.xml
  def new
    @account = Account.find(params[:account_id])
    @line = @account.lines.new
    @line.active = true

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @line }
    end
  end

  # GET /lines/1/edit
  def edit
    @account = Account.find(params[:account_id])
    @line = @account.lines.find(params[:id])
  end

  # POST /lines
  # POST /lines.xml
  def create
    @account = Account.find(params[:account_id])
    @line = @account.lines.new(params[:line])

    respond_to do |format|
      if @line.save
        flash[:notice] = 'Line was successfully created.'
        format.html { redirect_to account_lines_path(:page => params[:page], :search_string => params[:search_string]) }
        format.xml  { render :xml => @line, :status => :created, :location => @line }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @line.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /lines/1
  # PUT /lines/1.xml
  def update
    @account = Account.find(params[:account_id])
    @line = @account.lines.find(params[:id])

    respond_to do |format|
      if @line.update_attributes(params[:line])
        flash[:notice] = 'Line was successfully updated.'
        format.html { redirect_to account_lines_path(:page => params[:page], :search_string => params[:search_string]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @line.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /lines/1
  # DELETE /lines/1.xml
  def destroy
    @account = Account.find(params[:account_id])
    @line = @account.lines.find(params[:id])
    @line.destroy

    respond_to do |format|
      format.html { redirect_to :back }
      format.xml  { head :ok }
    end
  end
end
