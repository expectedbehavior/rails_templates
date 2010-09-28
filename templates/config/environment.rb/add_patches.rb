# patch string to have a good underscoring method
require File.join("#{RAILS_ROOT}/lib", 'patches/string')
ActionView::Base.field_error_proc = Proc.new { |html_tag, instance| "<span class=\"fieldWithErrors\">#{html_tag}</span>" }
ActiveResource::Base.logger = ActiveRecord::Base.logger
