require 'spec_helper'

describe User do
  # pending "add some examples to (or delete) #{__FILE__}"
  
  before(:each) do
    @attr = {:name => "Example User", :email => "user@example.com" }
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
end