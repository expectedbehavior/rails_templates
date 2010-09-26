When /^I go to the password reset url for "([^\"]*)"$/ do |user_email|
  print_page_on_error { visit @host + edit_password_reset_path(User.find_by_email(user_email).perishable_token) }
  assert_successful_response
end
