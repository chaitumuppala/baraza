require 'rails_ui_helper'

describe "the sign in process" do
  before :each do
    @password = "9YaybL(7"
    @user = create :user, { email: "user@example.com", password: @password, password_confirmation: @password }
  end

  it "signs me in" do
    @login_page.login(@user.email, @password)
    expect(page).to have_content("Signed in successfully")
  end
end