class MicropostsController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy] # it's better to specify which actions should be examed here.
  before_filter :authorized_user, :only => :destroy # only authorized_user can destroy their own microposts
  
  def create
    @micropost = current_user.microposts.build(params[:micropost]) #we need to use the User/Micropost relationship to build new microposts
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_path
    else
      @feed_items = [] # pass an empty array @feed_items to Home page, to suppress the failed submission break.
      render 'pages/home'
    end
  end
  
  def destroy
    @micropost.destroy
    redirect_back_or root_path
  end
    
  private
    def authorized_user
      @micropost = current_user.microposts.find_by_id(params[:id]) 
      # it's better to use .find_by_id (when fails, it return nil); but find() raise exception when failed.
      redirect_to root_path if @micropost.nil?
    end
end