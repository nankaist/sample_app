class UsersController < ApplicationController
  
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

end
