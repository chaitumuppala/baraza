Feature: Login

Scenario: User Login fails with invalid Username and Password
  Given I am on the homepage
    When Click Login
    And Provide "test@gmail.com" and "testing123" to login
    Then Validate error message "Invalid email or password."
    Then Close browser

Scenario:User Login fails with invalid Username and valid Password
  Given I am on the homepage
  And Click Login
  And Provide "test@gmail.com" and "Turtle.123" to login
  Then Validate error message "Invalid email or password."
  Then Close browser

Scenario: Login fails with valid Username and invalid Password
  Given I am on the homepage
  And Click Login
  And Provide "kumar.vastav@gmail.com" and "Testing" to login
  Then Validate error message "Invalid email or password."
  Then Close browser

Scenario: Login successful with valid Username and Password
  Given I am on the homepage
  And Click Login
  And Provide "kumar.vastav@gmail.com" and "Tester.123" to login
#  Then Validate successful user login
#  Then Logout the user
   Then Close browser