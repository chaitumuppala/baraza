require 'rails_helper'

describe "the sign in process" do
  before :each do
    create :user, { email: "user@example.com", password: "9YaybL(7", password_confirmation: "9YaybL(7" }
  end

  it "signs me in" do
    visit '/users/sign_in'
    within ".new-user-session" do
      fill_in "Email", with: "user@example.com"
      fill_in "Password", with: "9YaybL(7"
    end
    click_button "Log in"
    expect(page).to have_content("Signed in successfully")
  end
end
