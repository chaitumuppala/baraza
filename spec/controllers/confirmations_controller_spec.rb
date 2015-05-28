require 'rails_helper'

describe ConfirmationsController do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  context "after_resending_confirmation_instructions_path_for" do
    it "should redirect to root url after confirmation" do
      expect(controller.send(:after_confirmation_path_for, :user, create(:user))).to eq("/")
    end
  end

  context "create" do
    it "should return error response when email not found" do
      post :create, user: {email: "invalid@not_found.com"}

      expect(response.code).to eq("422")
      expect(response.body).to eq("Email not found")
    end
  end
end
