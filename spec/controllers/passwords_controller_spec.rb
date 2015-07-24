require 'rails_helper'

describe PasswordsController do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  context "create" do
    it "should send reset password for custom login users" do
      post :create, user: {email: create(:user).email}

      expect(response).to render_template("users/mailer/reset_password_instructions")
    end

    it "should not send reset password for social login users" do
      post :create, user: {email: create(:user, uid: "uid", provider: "google_oauth2").email}

      expect(response).to render_template("users/passwords/new")
    end
  end
end
