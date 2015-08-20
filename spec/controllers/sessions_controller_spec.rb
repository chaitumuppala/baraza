require 'rails_helper'

describe SessionsController do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end
  it "should skip redirecting to change email if email not set" do
    user = create(:user, uid: "uid", provider: "facebook", email: nil)
    user.update_attributes!(email: nil)
    sign_in user
    delete "destroy"
    expect(response).to redirect_to(root_path)
  end

  context "after_sign_path_for" do
    it 'should redirect to root_path after sign_in for general links' do
      password = "password1!"
      user = create(:user, password: password)
      session[:user_return_to] = articles_url
      post :create, {:user => {email: user.email, password: password}}
      expect(response).to redirect_to root_path
    end

    it 'should redirect to article_show after sign_in for article show links' do
      password = "password1!"
      creator = create(:creator, password: password)
      article = create(:article, creator: creator)
      session[:user_return_to] = article_url(article)
      post :create, {:user => {email: creator.email, password: password}}
      expect(response).to redirect_to article_url(article)
      expect(session[:user_return_to]).to be_nil
    end
  end
end