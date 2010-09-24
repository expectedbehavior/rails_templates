puts "NOTE::::::: This only work if you run it through the run.sb script.  Do not run 'rails' directly!"

TEMPLATE_ROOT = File.dirname(File.expand_path(template))

require File.join(TEMPLATE_ROOT, 'template_segment.rb')
TemplateSegment.templates_path = File.join(TEMPLATE_ROOT, "templates")

TemplateSegment.run_segments(File.join(TEMPLATE_ROOT, "segments"), self)
