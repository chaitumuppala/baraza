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
end