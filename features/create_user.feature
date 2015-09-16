Feature: Create User

  Scenario: Sign up a new user
    Given I am on the homepage
    And Open new user form with Signup
    And Enter First name "Test"
    And Enter Last name "User"
    And Enter Email "test@test.com"
    And Enter Password "Turtle.123"
    And Enter Confirm Password "Turtle.123"
    And Enter Date of Birth "1984"
    And Enter Country "India"
    And Select Gender "Male"
    And Click Register a new user
    Then Validate success message is "A message with a confirmation link has been sent to your email address. Please follow the link to activate your account."
    Then Close browser