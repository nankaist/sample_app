require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'new'" do
    it "should be successful" do
      get :new # same with get 'new'
      response.should be_success
    end
    
    it "should have the right title" do
      get :new
      response.should have_selector('title', :content => 'Sign up')
    end
    #tests for the presence of fields in the signup page
    it "should have a name field" do
      get :new
      response.should have_selector("input[name='user[name]'][type='text']")
    end
    it 'should have a email field' do
      get :new
      response.should have_selector("input[name='user[email]'][type='text']")
    end
    it 'should have a password field' do
      get :new
      response.should have_selector("input[name='user[password]'][type='password']")
    end
    it 'should have a password confirmation field' do
      get :new
      response.should have_selector("input[name='user[password_confirmation]'][type='password']")
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
  
  describe "POST 'create'" do
    describe "failure" do
      before(:each) do
        @attr = { :name => "", :email => "",
                  :passowrd => "", :password_confirmation => ""}
      end
        
      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count) # verify that create action not create a new user in db, 
                                            # aka, it not "change" the entry :count of User db 
      end
        
      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector("title", :content=>"Sign up")
      end
        
      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new') # after a failure, re-render the new user page
      end
    end
    
    describe "success" do
      before(:each) do
        @attr = { :name => "New User", :email => "user@example.com",
                  :password => "foobar", :password_confirmation => "foobar"}
      end
      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1) # store in database successful, User database :count +1
      end
      it "should redirect to the user show page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end
      it "should have a welcome message" do # test for a successful user signup flash msg
        post :create, :user => @attr
        flash[:success].should =~ /welcome to the sample app/i
      end
    end
    
  end
  
end
