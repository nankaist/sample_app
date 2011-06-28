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
  #!!!this line make two attributes accessible for outside users, and other attributes not.
  attr_accessible :name, :email 
  
  # validate the presence of attributes
  validates :name, :presence => true,
                   :length => {:maximum => 50}
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,  :presence => true,
                    :format => {:with => email_regex},
                    :uniqueness => { :case_sensitive => false }
  
  
end