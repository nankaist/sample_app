module ApplicationHelper
  
  # Return a title on a per-page basis
  def title
    base_title = 'Ruby on Rails Tutorial Sample App'
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
  
  # define logo helper for _head.html.erb partial
  def logo
    image_tag("facebook.png", :alt => "Sample App", :class => "round")
  end
  	
  
end
