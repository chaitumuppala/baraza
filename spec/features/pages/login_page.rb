class LoginPage
  include Capybara::DSL
  def login(email="user@example.com", password="9YaybL(7")
    visit '/users/sign_in'
    within ".new-user-session" do
      fill_in "Email", with: email
      fill_in "Password", with: password
    end
    click_button "Log in"
  end
end