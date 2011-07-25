require 'spec_helper'

describe User do
  # pending "add some examples to (or delete) #{__FILE__}"
  
  before(:each) do
    @attr = {
      :name => "Weichao Chou",
      :email => "wchou@gmail.com",
      :password => "foobar",
      :password_confirmation => "foobar"
      }
  end
  
  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end
  
  # pending "should require a name"  # right now, it's just a pending test
  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name=>''))
    no_name_user.should_not be_valid
  end
  
  it "should require a email" do
    no_email_user = User.new(@attr.merge(:email=>''))
    no_email_user.should_not be_valid
  end
  
  it "should reject names that are too long" do
    long_name = "a"*51
    long_name_user = User.new(@attr.merge(:name=>long_name))
    long_name_user.should_not be_valid
  end
  
  it "should accept valid email addresses" do
    addresses = %w[userr@foo.com The_user@foo.bar.org w.chou@foo.com]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end
  
  it "should reject invalid email adresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end
  
  it "should reject duplicate email addresses" do # Uniqueness validation test
    #put a user with given email address into the database
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
  
  it "should reject eamil addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email=>upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
  
  #password validation test
  describe "password validations" do
    it "should require a password" do
      User.new(@attr.merge(:password=>"",:password_confirmation=>"")).should_not be_valid
    end
    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation=>"invalid")).should_not be_valid
    end
    it "should reject short passwords" do
      short = "a"*5
      attr_shortpwd= @attr.merge(:password=>short, :password_confirmation=>short)
      User.new(attr_shortpwd).should_not be_valid
    end
    it "should reject long passwords" do
      long = "a"*41
      attr_longpwd = @attr.merge(:password=>long, :password_confirmation=>long)
      User.new(attr_longpwd).should_not be_valid
    end
  end
  
  #Test for the existence of an encrypted password attribute
  describe "password encryption" do
    before (:each) do
      @user = User.create!(@attr)
    end
    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end
    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end
    it "should be true if the passwords match" do
      @user.has_password?(@attr[:password]).should be_true
    end
    it "should be false if the passwords don't match" do
      @user.has_password?("invalid").should be_false
    end
    # tests for the User.authenticate(email,submitted_password)
    it "should return nil on email/password mismatch" do
      wrong_password_user = User.authenticate(@attr[:email],'wrongpass')
      wrong_password_user.should be_nil
    end
    it "should reutrn nil for an email address with no user" do
      nonexistent_user = User.authenticate('bar@foo.com', @attr[:password])
      nonexistent_user.should be_nil
    end
    it "should return the user on email/password match" do
      matching_user = User.authenticate(@attr[:email], @attr[:password])
      matching_user.should == @user
    end    
  end
  
  describe "admin attribute" do
    before(:each) do
      @user = User.create!(@attr)
    end
    it 'should respond to admin' do
      @user.should respond_to(:admin)
    end
    it "should not be an admin by default" do
      @user.should_not be_admin
    end
    it "should be convertible to an admin" do
      @user.toggle!(:admin) # toggle!() to flip the admin attr from false to true
      @user.should be_admin # be_admin implies that user should have an admin? boolean method
    end
  end
  
  describe 'micropost associations' do # test for user's micropost attribute
    before(:each) do
      @user = User.create (@attr)
      @mp1 = Factory(:micropost, :user => @user, :created_at => 1.year.ago)
      @mp2 = Factory(:micropost, :user => @user, :created_at => 1.hour.ago)
    end
    it "should have a microposts attribute" do
      @user.should respond_to(:microposts)
    end
    it "should have the right microposts in the right order" do
      @user.microposts.should == [@mp2, @mp1] # test that the posts should be ordered newest first
    end
    it "should destroy associated microposts" do
      @user.destroy
      [@mp1, @mp2].each do |micropost|
        # .find_by_id() return nil if not found; while .find() raises exception on failure
        # the three lines below is the same with find_by_id line:
        # lambda do
          # Micropost.find(micropost.id)
        # end.should raise_error(ActiveRecord::RecordNotFound)
        Micropost.find_by_id(micropost.id).should be_nil
      end
    end
    describe "status feed" do
      it "should have a feed" do
        @user.should respond_to(:feed)
      end
      it "should include the user's microposts" do
        @user.feed.include?(@mp1).should be_true # include?() checks if an array includes the given element.
        @user.feed.include?(@mp2).should be_true
      end
      it "should not include a different user's microposts" do
        mp3 = Factory(:micropost, :user => Factory(:user, :email => Factory.next(:email)))
        @user.feed.include?(mp3).should be_false
      end
    end
  end
  
  describe "relationships" do
    before(:each) do
      @user = User.create!(@attr)
      @followed = Factory(:user)
    end
    it "should have a relationships method" do
      @user.should respond_to(:relationships)
    end
    it "should have a following method" do
      @user.should respond_to(:following)
    end
    it "should have a following? method" do
      @user.should respond_to(:following?)
    end
    it "should have a follow! method" do
      @user.should respond_to(:follow!)
    end
    it "should follow another user" do
      @user.follow!(@followed)
      @user.should be_following(@followed)
    end
    it "should include the followed user in the following array" do
      @user.follow!(@followed)
      @user.following.should include(@followed) # more succinct than .following.include?(@followed).should be_true
    end
    it "should have an unfollow! method" do
      @user.follow!(@followed)
      @user.unfollow!(@followed)
      @user.should_not be_following(@followed)
    end
    
  end
  
end
