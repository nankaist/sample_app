require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'new'
      response.should have_selector('title', :content => 'Sign up')
    end
  end
  
  describe "GET 'show'" do
    before(:each) do
      @user = Factory(:user)
    end
    
    it "should be successful" do
      get :show, :id => @user # same with get :show, :id => @user.id, rails auto convert .id to @user itself
      response.should be_success
    end
    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user # this line verifies that the variable retrieved from db in action corresponds to the @user instance created by Factory Girl.
    end
    
    it "should have the right title" do
      get :show, :id => @user
      response.should have_selector("title", :content => @user.name)
    end
    it "should have the user's name" do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.name)
    end
    it "should have a profile image" do
      get :show, :id => @user
      response.should have_selector("h1>img", :class => "gravatar") # test if img tag in h1 tag, and CSS of it => gravatar
    end
    
  end
  
end
