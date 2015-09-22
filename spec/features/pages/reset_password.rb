class PasswordResetPage
  include Capybara::DSL

  def goto_password_reset
    visit 'users/password/new'
  end

  def enter_email(email)
    fill_in 'email', :with => email
  end

  def click_to_continue
    find(:id,"resetPassword").click
  end
end