class LoginPage
  include Capybara::DSL
<<<<<<< HEAD
  def login(email, password)
=======
  def login(email="user@example.com", password="9YaybL(7")
>>>>>>> ad844b7f32939b03f31c729c40f9276bbefdf675
    visit '/users/sign_in'
    within ".new-user-session" do
      fill_in "Email", with: email
      fill_in "Password", with: password
    end
    click_button "Log in"
  end
<<<<<<< HEAD
end
=======
end
>>>>>>> ad844b7f32939b03f31c729c40f9276bbefdf675
