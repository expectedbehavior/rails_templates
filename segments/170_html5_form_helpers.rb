# https://github.com/jessedearing/html5_rails2_plugin.git
# good for doing special types of input fields; mostly useful for mobile dev e.g. phone_field
# <%= f.search_field :search, "Search something..." %>
# <%= f.telephone_field :phone, "123-456-7890" %>
# <%= f.number_field :number, 5, :step => 1, :min => 0, :max => 10 %>
# <%= f.range_field :range, 5, :min => 0, :max => 10 %>
# <%= f.email_field :email, "person@email.com" %>
# <%= f.url_field :url, "http://github.com" %>
# <%= f.datetime_field :publish_at, 5.hours.from_now %>
# <%= f.color_field :background_color, "#f34be3" %>

class Html5FormHelpers < TemplateSegment
  def required?
    true
  end
  
  def starting_message
    "Installing HTML5 Form Helpers"
  end
  
  def ending_message
    "now with more form input helpers"
  end
  
  def commit_message
    "html5 form helpers added"
  end
  
  def run_segment
    self.plugin 'html5-helpers', :git => 'https://github.com/jessedearing/html5_rails2_plugin.git'
  end
end
