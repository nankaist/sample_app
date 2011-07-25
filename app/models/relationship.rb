class Relationship < ActiveRecord::Base
  attr_accessible :followed_id # not the follower_id accessible
  #Rails infers the name of foreign key from the symbols(follower_id from :follower, followed_id from followed)
  # since there is no followed and follower model, we need to supply the class name User.
  belongs_to :follower, :class_name => "User" 
  belongs_to :followed, :class_name => "User"

  # validations for relationship model
  validates :follower_id, :presence => true
  validates :followed_id, :presence => true
end
