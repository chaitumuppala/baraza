require 'rails_helper'

describe PasswordsController do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  context "create" do
    it "should redirect to root_path on success" do
      post :create, user: {email: create(:user).email}

      expect(response.code).to eq("302")
      expect(response).to redirect_to(root_path)
    end

    it "should return error response when email not found" do
      post :create, user: {email: "invalid@not_found.com"}

      expect(response.code).to eq("422")
      expect(response.body).to eq("Email not found")
    end

    it "should not send reset password for social login users" do
      post :create, user: {email: create(:user, uid: "uid", provider: "google_oauth2").email}

      expect(response.code).to eq("422")
      expect(response.body).to eq("Email not found")
    end
  end
end
