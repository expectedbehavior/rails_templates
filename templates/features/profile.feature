Feature: User Profile
  In order to keep their personal information up to date and secure
  As a user
  I should be able to update their names, email, and passwords

  @ok @shouldwork
  Scenario: View My Profile
    Given I am logged in as John Smith
    When I view my profile
    Then I should see "John"
    And I should see "Smith"
    And I should see "ebtestfakeaccount+johnsmith@gmail.com"
    And I should see a link with text "Edit"

  @ok @shouldwork
  Scenario: Edit my name and email and login
    Given I am logged in as John Smith
    When I view my profile
    And I click "Edit"
    Then I should see "First name"
    And I should see "Last name"
    And I should see "Email"
    And I should see a button with text "Submit"
    When I fill in "First name" with "Johann"
    And I fill in "Last name" with "Smithe"
    And I fill in "Email" with "ebtestfakeaccount+johannsmithe@gmail.com"
    And I press "Submit"
    Then I should see "Your profile was successfully updated."
    And I should see "Johann"
    And I should see "Smithe"
    And I should see "ebtestfakeaccount+johannsmithe@gmail.com"
    And I should see a link with text "Edit"
    When I logout
    And I go to the login page
    And I fill in "Email" with "ebtestfakeaccount+johannsmithe@gmail.com"
    And I fill in "Password" with "secret"
    And I press "Submit"
    Then I should see "Login successful!"
    
  @ok @shouldwork
  Scenario: Change password and login
    Given I am logged in as John Smith  
    When I view my profile
    And I click "Edit"
    And I fill in "Password" with "popsecret"
    And I fill in "Password confirmation" with "popsecret"
    And I press "Submit"
    Then I should see "Your profile was successfully updated."
    When I logout
    And I go to the login page
    And I fill in "Email" with "ebtestfakeaccount+johnsmith@gmail.com"
    And I fill in "Password" with "popsecret"
    And I press "Submit"
    Then I should see "Login successful!"
