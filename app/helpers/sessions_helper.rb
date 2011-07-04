module SessionsHelper
  
  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user = user
  end
  
  def sign_out # just do the opposite of sign_in above
    cookies.delete(:remember_token)
    self.current_user = nil
  end
  
  def current_user=(user) # when operater defining, there should not be space between them, like current_user = () is wrong.
    @current_user = user
  end
  
  def current_user
    @current_user ||= user_from_remember_token # a ||= b is a = a || b is equal to a = b only if a == nil 
  end
  
  def signed_in?
    !current_user.nil?
  end
  
  
  private
    def user_from_remember_token
      # remember_token returns a 2-elements array, but authenticate method need 2 seperate variables
      # so, * allows us to use a 2-elements array as an argument to a method expecting 2 variables
      User.authenticate_with_salt(*remember_token) 
    end
    def remember_token
      # if cookies is nil, reutrn [nil,nil], this is used to fix the breakage caused by cookies is nil
      cookies.signed[:remember_token] || [nil,nil] 
    end
  
end
