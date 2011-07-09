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


  def character_count(field_id, update_id, options = {})
    function = "$('#{update_id}').innerHTML = $F('#{field_id}').length;"
    out = javascript_tag(function) # set current length
    out += observe_field(field_id, options.merge(:function => function)) # and observe it
  end
  
  
end
