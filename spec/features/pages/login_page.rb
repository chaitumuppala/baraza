class LoginPage
  include Capybara::DSL
  def login(email="email3@factory.com ", password="Password1!")
    visit '/users/sign_in'
    within ".new-user-session" do
      fill_in "Email", with: email
      fill_in "Password", with: password
    end
    click_button "Log in"
  end
end
