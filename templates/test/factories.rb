Factory.define(:user) do |u|
  u.sequence(:email) { |n| "email#{n}@example.com" }
  u.first_name "John" 
  u.last_name  "Doe"
  u.password   "secret"
  u.password_confirmation "secret"
end
