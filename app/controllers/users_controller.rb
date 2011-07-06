class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy] #before_filter arrange for a particular method to be called before the given actions(actions are restriced after :only)
  before_filter :correct_user, :only => [:edit, :update] # for the wrong user not to access :edit and :update
  before_filter :admin_user, :only => :destroy # restrict :destroy action to admins
  before_filter :no_new_after_signin, :only => [:new, :create] # no need for sigin user to new/create again, so redirect to root_path
  
  def index
    @title = "All users"
    # @users = User.all # show users without pagination
    # show with pagination, paginate return collection; :page in params generated automatically by will_paginate in views
    # default :per_page == 30
    @users = User.paginate(:page => params[:page], :per_page => 10) 
  end
  
  def show
    @user = User.find(params[:id]) # define @user for the view 
    @title = @user.name # a title for user show page
  end
  
  def new
    @user = User.new
    @title = "Sign up"
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      # handle a successful save.
      sign_in @user #auto signin upon signup
      flash[:success] = "Welcome to the Sample App!" # set up success flash message
      redirect_to @user #rails know it should redirect to user_path(@user)
    else
      @title = "Sign up"
      @user.password = nil # reset user.password to clean the password in form after signup failure
      @user.password_confirmation = nil
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id]) # this can be omitted 'cos we have before_filter
    @title = "Edit user"
  end
  
  def update
    @user = User.find(params[:id]) # this can be omitted 'cos we have before_filter
    if @user.update_attributes(params[:user]) 
      flash[:success] = "Profile updated!"
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end
  
  def destroy
    user_to_be_destroy = User.find(params[:id])
    if user_to_be_destroy.admin? # not destroy admin user
      flash[:error] = "Admin user can't be destroyed!"
    else
      user_to_be_destroy.destroy # really destroy a user
      flash[:success] = "User destroyed !"
    end
    redirect_to users_path
  end
  
  private
    def authenticate # for before_filter to authenticate signin status before actions
      deny_access unless signed_in? #deny_access defined in sessions_helper.rb
    end
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
    def no_new_after_signin # not enter new page after already signin
      redirect_to(root_path) if signed_in?
    end

end
