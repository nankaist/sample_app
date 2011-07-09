require 'spec_helper'

describe Micropost do
  before(:each) do
    @user = Factory(:user)
    @attr = {:content => "value for content"}
  end
  it 'should create a new instance given valid attributes' do
    @user.microposts.create!(@attr)
  end
  describe "user associations" do
    before(:each) do
      @micropost = @user.microposts.create(@attr)
    end
    it "should have a user attribute" do
      @micropost.should respond_to(:user)
    end
    it "should have the right associated user" do
      @micropost.user_id.should == @user.id
      @micropost.user.should == @user
    end
  end
  describe "validations" do
    it "should require a user id" do
      Micropost.new(@attr).should_not be_valid # .new not set user_id, 'cos no user_id in @attr
    end
    it "should require nonblank content" do
      #@user.microposts.build() is same with Micropost.new except it auto sets the micropost's user_id to @user.id.
      @user.microposts.build(:content => " ").should_not be_blank 
    end
    it "should reject long content" do
      @user.microposts.build(:content => "a"*141).should_not be_valid
    end
  end
end
