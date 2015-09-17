Feature: Sign in Page




Scenario: Loggin in with the correct details
 Given I am on the signin page
 When I login with "admin@example.com" and "password1!"
 And I click on the "Log in" button
 Then I should see "Signed in successfully."
 And Close the browser

