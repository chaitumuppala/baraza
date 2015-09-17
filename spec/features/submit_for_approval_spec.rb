require 'rails_ui_helper'

describe "submit_for_approval" do
  before :each do
    @password = "Password1!"
    @user = create :user, password: @password
    @article = create :article, creator: @user
    @article.users << @user
  end

  it "should submit the registered user article for approval" do
    @login_page.login(@user.email, @password)
    @article_list_page.list
    @article_page.edit @article

    @article_page.submit_for_approval

    expect(page).to have_content("Article was successfully updated.")
    expect(page).to have_content("submitted for approval")

    @article_page.view @article
    expect(page).not_to have_content("Edit")
  end
end