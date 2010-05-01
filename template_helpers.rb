puts "evaluating template helper template"
def ensure_required_gem(gem)
  load gem
rescue Exception => e
  raise_message = "Could not find any version of #{gem} and it's apparently required. This check is really dumb right now, so if you're sure you have the gem you may need to make the require check more sophisticated."
  raise raise_message
end 



