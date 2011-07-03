module UsersHelper
  
  # gravatar helper, setup gravatar's :email, :alt, css :class and other option like size
  def gravatar_for(user, options = {:size => 50 })
    gravatar_image_tag(user.email.downcase, :alt => user.name, #Gravatar is case-sensitive
                                            :class => 'gravatar',
                                            :gravatar => options)
  end
    
end
