require 'rails_ui_helper'

describe "the sign in process" do
  before :each do
    @password = "9YaybL(7"
    @user = create :user, { email: "user@example.com", password: @password, password_confirmation: @password }
  end

  it "User Login fails with invalid Username and Password" do
    @login_page.login("invalid@mail.com", "justpass")
    expect(page).to have_content("Invalid email or password.")
  end

  it "User Login fails with invalid Username and valid Password" do
    @login_page.login("invalid@mail.com", @password)
    expect(page).to have_content("Invalid email or password.")
  end

  it "User Login fails with valid Username and invalid Password" do
    @login_page.login(@user.email, "justpass")
    expect(page).to have_content("Invalid email or password.")
  end

  it "User Login successful with valid Username and Password" do
    @login_page.login(@user.email, @password)
    expect(page).to have_content("Signed in successfully")
  end
end