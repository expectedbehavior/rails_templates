Given /^I am logged in as John Smith$/ do
  Given "there is a user named \"John Smith\""
  Given "that user has \"email\" set to \"ebtestfakeaccount+johnsmith@gmail.com\""
  Given "I am on the login page"
  When "I fill in \"Email\" with \"ebtestfakeaccount+johnsmith@gmail.com\""
  When "I fill in \"Password\" with \"secret\""
  When "I press \"Submit\""
  Then "I should see \"Login successful!\""
end

When /^I logout$/ do
  When "I go to logout"
  Then "I should see \"Logout successful!\""
end
