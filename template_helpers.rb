######################################
# Set valuable constants
######################################
# puts "#{File.dirname(__FILE__)}"
# puts "#{File.expand_path(File.dirname(__FILE__))}"
# File.dirname(File.expand_path(__FILE__))
# puts TEMPLATE_ROOT
# puts jruby_template_path




# puts "evaluating template helper template"



def ensure_required_gem(gem)
  require gem
rescue Exception => e
  raise_message = "Could not find any version of #{gem} and it's apparently required. This check is really dumb right now, so if you're sure you have the gem you may need to make the require check more sophisticated."
  raise raise_message
end 

# Yes, this is implemented stupidly. It'll get better later.
def ensure_required_command(command)
  raise if `which #{command}`.blank?
rescue Exception => e
  raise_message = "Could not find any version of #{gem} and it's apparently required. This check is really dumb right now, so if you're sure you have the gem you may need to make the require check more sophisticated."
  raise raise_message
end 

def add_plugin_with_setup(*args, &block)
  return_value = plugin(*args)
  if block_given?
    return_value = yield
  end 
  return_value
end



def announce(text)
  puts ""
  puts "==================================="
  puts "=== #{text}"
  puts "==================================="
  puts ""
end



require 'highline/import'
HighLine.track_eof = false # workaround for pthread enabled systems

# this allows an easy way of asking yes/no questions with a default (or other options as well)
def agree_question( yes_or_no_question, character = nil )
  HighLine.ask(yes_or_no_question, lambda { |yn| yn.downcase[0] == ?y}) do |q|
    q.validate                 = /\Ay(?:es)?|no?\Z/i
    q.responses[:not_valid]    = 'Please enter "yes" or "no".'
    q.responses[:ask_on_error] = :question
    q.character                = character
    yield q if block_given?
  end
end
