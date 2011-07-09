class Micropost < ActiveRecord::Base
  attr_accessible :content # restrict the :content the only accessible attr, not the user_id
  
  belongs_to :user # a micropost belongs_to a user
  
  validates :content, :presence => true, :length => {:maximum => 140}
  validates :user_id, :presence => true
  
  default_scope :order => 'microposts.created_at DESC' # order posts with default_scope, DESC is SQL for descending(newest to oldest)

end
