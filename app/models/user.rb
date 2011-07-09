# == Schema Information
# Schema version: 20110626012607
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#------the comment above is created by bundle exec annotate command !! it is very good------

class User < ActiveRecord::Base
  attr_accessor :password # create a virtual password attribute
  #!!!this line make two attributes accessible for outside users, and other attributes not.
  attr_accessible :name, :email, :password, :password_confirmation
  
  has_many :microposts, :dependent => :destroy # user has_many microposts, and the :destroy of posts is dependent on user.(aka, it user is destroyed, its posts too.)
  
  # validate the presence of attributes
  validates :name, :presence => true,
                   :length => {:maximum => 50}
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,  :presence => true,
                    :format => {:with => email_regex},
                    :uniqueness => { :case_sensitive => false }
                    
  #Automatically create the virtual attribute 'password_confirmation'.
  validates :password, :presence => true,
                      :confirmation => true,
                      :length => { :within => 6..40}
  

  # return true if the user's password matches the submitted password
  def has_password?(submitted_password)
    #compare encrypted_password with the encrypted version of submitted_password
    encrypted_password == encrypt(submitted_password)
  end
  
  def self.authenticate(email, submitted_password) # it is same with using "User.authenticate(...)"
    user = find_by_email(email)
    return nil if user.nil? # for user not exist
    return user if user.has_password?(submitted_password) # for user/password match
    return nil # explicit return for the non-match situation (this line can be deleted, meaning a implicit return nil)
    # the 3 lines above can be written as:
    # user && user.has_password?(submitted_password) ? user : nil
  end
  
  # authenticate method for cookie
  def self.authenticate_with_salt(id,cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt)? user : nil
    # or same with
    # return nil if user.nil?
    # reutrn user if user.salt == cookies_salt
  end
  
  def feed
    # this is preliminary. full implementaion in Chapter 12
    Micropost.where("user_id = ?", id) # use "?" to ensuer id is escaped before being included in SQL query, which prevent SQL injection.
  end
  
  # a callback to create the encryted_password attribute
  before_save :encrypt_password
  # all methords defined after private are used internally by the object and are not intended for public use.
  private
    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(self.password)
    end
    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
    
end