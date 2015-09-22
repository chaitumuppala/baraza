require 'rails_ui_helper'

describe 'Request password reset instruction' do
  before :each do
    @password_reset_page.goto_password_reset
  end

  it 'should check if the link is visible' do
    @login_page.goto_login
    expect(page).to have_content("Forgot your password?")
  end

  it 'Error message appear when requesting password reset with empty email' do
    @password_reset_page.click_to_continue
    expect(page).to have_content("Email can't be blank")
  end

  it 'Error message appear when requesting password reset with unregisterd email' do
    @password_reset_page.enter_email("unregistered@mail.com")
    @password_reset_page.click_to_continue
    expect(page).to have_content("Email not found")
  end

  it 'Successful sending of password reset instruction when providing a registered email' do
    @password_reset_page.enter_email("email3@factory.com")
    @password_reset_page.click_to_continue
    expect(page).to have_content("You will receive an email with instructions on how to reset your password in a few minutes. ")
  end

end