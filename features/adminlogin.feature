Feature: Sign in Page

Scenario: Loggin in with the correct details
 Given I am on the signin page
 When I login with "admin@mt2015.com" and "Password1!"
 And I click on the "Log in" button
 Then I should see "Signed in successfully."
 And Close the browser

