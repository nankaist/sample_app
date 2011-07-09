module SessionsHelper
  
  # # these sign_in sign_out current_user methods are for browser session, aka auto sign_out after browser closed.
  # def sign_in(user)
  #   session[:remember_token] = user.id
  #   self.current_user = user
  # end
  # def sign_out
  #     reset_session # to remove the entire session
  #     self.current_user = nil
  # end
  # def current_user
  #   @current_user ||= User.find_by_id(session[:remember_token])
  # end
  
  # these sign_in sign_out current_user methods are for permanent user cookies, aka not sign_out util click sign_out explicitly.
  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user = user
  end
  def sign_out # just do the opposite of sign_in above
    cookies.delete(:remember_token)
    self.current_user = nil
  end  
  def current_user
    @current_user ||= user_from_remember_token # a ||= b is a = a || b is equal to a = b only if a == nil 
  end
  
  def current_user=(user) # when operater defining, there should not be space between them, like current_user = () is wrong.
    @current_user = user
  end
  
  def signed_in?
    !current_user.nil?
  end

  def authenticate # for before_filter to authenticate signin status before actions
    deny_access unless signed_in? #deny_access defined in sessions_helper.rb
  end
  
  def deny_access
    store_location # used for friendly forwarding
    # flash[:notice] = "Please sign in ..."
    # redirect_to signin_path
    # it is same with code above, it also works for :error , :success keys
    redirect_to signin_path, :notice => "Please sign in to access this page!"
  end
  
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end
  
  def current_user?(user)
    user == current_user
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
   def store_location # use session[:return_to] to remember the path of browser's request, for friendly forwarding
     session[:return_to] = request.fullpath
   end
   def clear_return_to
     session[:return_to] = nil
   end
  
end
