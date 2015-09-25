require 'rails_ui_helper'

describe 'add author' do
  before :each do
    @password = "Password1!"
    @user = create :user, password: @password
    @article = create :article, creator: @user
    @article.users << @user
  end

  it 'should add author' do
    @login_page.login("email3@factory.com" , @password)
    expect(page).to have_content("Signed in successfully")
    @home_page.home
    @home_page.click_username
    @add_author_page.go_to_authors
    @add_author_page.enter_author_details("Hans M","hm@mail.com")
    #expect(page).to have_content("Author was successfully created.")
  end
end