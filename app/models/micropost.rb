class Micropost < ActiveRecord::Base
  attr_accessible :content # restrict the :content the only accessible attr, not the user_id
  
  belongs_to :user # a micropost belongs_to a user
  
  validates :content, :presence => true, :length => {:maximum => 140}
  validates :user_id, :presence => true
  
  default_scope :order => 'microposts.created_at DESC' # order posts with default_scope, DESC is SQL for descending(newest to oldest)

  def self.search(search) # search the content with the keyword #{search}
    unless search.empty?
      find(:all, :conditions => ['content LIKE ?', "%#{search}%"]) 
    else
      find(:all)
    end
  end

  # def self.from_users_followed_by(user)
    # following_ids = user.following_ids # user.following_ids is the name for user.following.map(&:id), rails support it.
    # pull all followed user into memory, not efficient enough
    # where("user_id IN (#{following_ids}) OR user_id = ?", user)
    # the following line is same with the previous two line.
  # end
  
  # scope used to restricting database selects based on certain conditions. it can make the pagination happened from database.
  # return microposts from the users being followed by the given user.
  # the argument after , is the selects conditions.
  scope :from_users_followed_by, lambda { |user| followed_by(user) }
  
  private
    #return an SQL condition for users followed by the given user
    # we include the user's own id as well
    def self.followed_by(user)
      following_ids = %(SELECT followed_id FROM relationships WHERE follower_id = :user_id)
      where("user_id IN (#{following_ids}) OR user_id = :user_id", {:user_id => user})
    end
    # the result is like for user_1:
    # SELECT * FROM microposts
    # WHERE user_id IN (SELECT followed_id FROM relationships
    #                   WHERE follower_id = 1)
    #       OR user_id = 1
  

  
end
