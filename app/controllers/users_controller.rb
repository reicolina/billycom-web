class UsersController < ApplicationController
  before_filter :check_master, :only => [:new, :index, :create, :destroy]
  skip_before_filter :require_user
  before_filter :require_user, :only => [:edit, :update]
  
  def index
    @users = User.find(:all, :include => 'site', :order => "sites.name, username")
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end
    
  def new
    @user = User.new
    @companies = Site.find(:all)
  end
  
  def create
    @user = User.new(params[:user])
    @companies = Site.find(:all)
    if @user.save_without_session_maintenance
      flash[:notice] = "Successfully created user."
      redirect_to users_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated user."
      redirect_to root_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
    
end
