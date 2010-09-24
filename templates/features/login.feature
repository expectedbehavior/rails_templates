Feature: Logging in
  In order to access the system
  As a user
  I want to login to the system

  @1 @shouldwork @happy_case
  Scenario: Sign up and log into the system
    Given I am on the home page
    When I follow "Signup"
    And I fill in "Email" with "billy@example.com"
    And I fill in "First name" with "Billy"
    And I fill in "Last name" with "Bob"
    And I fill in "Password" with "secret"
    And I fill in "Password confirmation" with "secret"
    And I press "Submit"
    Then I should see "Thanks for signing up"
    When I follow "Logout"
    And I follow "Login"
    And I fill in "Email" with "billy@example.com"
    And I fill in "Password" with "secret"
    And I press "Submit"
    And I should see "Login successful!"
