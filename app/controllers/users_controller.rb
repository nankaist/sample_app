class UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id]) # define @user for the view 
    @title = @user.name # a title for user show page
  end
  
  def new
    @title = "Sign up"
  end

end
