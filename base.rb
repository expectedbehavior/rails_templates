puts "NOTE::::::: This will only work if you run it through the run.rb script.  Do not run 'rails' directly!"
require 'ruby-debug'
Debugger.start
debugger
TEMPLATE_ROOT = File.dirname(File.expand_path(path))

require File.join(TEMPLATE_ROOT, 'template_segment.rb')
TemplateSegment.templates_path = File.join(TEMPLATE_ROOT, 'templates')
require File.join(TEMPLATE_ROOT, 'templates', 'lib', 'patches', 'string.rb')

TemplateSegment.run_segments(File.join(TEMPLATE_ROOT, 'segments'), self)

puts "If you migrated and setup your servers with the web server config tool, you should now be able to run 'rake' without arguments to make sure everything is working correctly."
