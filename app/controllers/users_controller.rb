class UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id]) # define @user for the view 
  end
  
  def new
    @title = "Sign up"
  end

end
