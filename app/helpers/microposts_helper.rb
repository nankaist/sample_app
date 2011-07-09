module MicropostsHelper


  def wrap(content) # used to wrap long strings that could break the layout of webpages.
    sanitize(raw(content.split.map{ |s| wrap_long_string(s) }.join(' ')))
    # sanitize() can prevent cross-site scripting.
    # raw() tells rails not to auto escaping html tags.
  end

  private
    def wrap_long_string(text, max_width = 30)
      zero_width_space = "&#8203;" # space with no width, used to seperate long string
      regex = /.{1,#{max_width}}/
      (text.length < max_width) ? text : text.scan(regex).join(zero_width_space)
    end
end