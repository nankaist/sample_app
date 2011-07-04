class SessionsController < ApplicationController
  def new
    @title = "Sign in"
  end

  def create
    # user params hash to extract :session and the :email and :password in :session
    user = User.authenticate(params[:session][:email], params[:session][:password])
    if user.nil?
      @title = "Sign in"
      flash.now[:error] = "Invalid email/password combination!" # flash.now waits render and then disappears; but, flash waits re_direct
      render 'new'
    else
      # sign the user in and redirect to the user's show page.
      flash[:success] = "Successful Log in! " # flash waits for redirect_to
      sign_in user
      redirect_to user
    end
  end
  
  def destroy # destroying session, user signout
    sign_out
    redirect_to root_path
  end
  
end
