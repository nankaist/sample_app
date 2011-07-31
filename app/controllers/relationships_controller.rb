class RelationshipsController < ApplicationController
  before_filter :authenticate
  
  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)
    respond_to do |format| # take proper action depending on the kind of request
                           # only one of the following lines gets executed.(based on the nature of request)
      #different response for diff request format standard/Ajax
      format.html {redirect_to @user}
      format.js #when got Ajax request, rails auto call .js.erb file with same name as the action(create.js.erb...)
    end
  end
  
  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    respond_to do |format|
      format.html {redirect_to @user}
      format.js
    end
    
  end
end