class PagesController < ApplicationController
  def home
    @title = "Home"
    if signed_in? # to pass micropost and feed_items instance variable to home page in view when signin
      @micropost = Micropost.new 
      @feed_items = current_user.feed.paginate(:page => params[:page])
    end
  end

  def contact
    @title = "Contact"
  end
  
  def about
    @title = "About"
  end
  
  def help
    @title = "Help"
  end

end
