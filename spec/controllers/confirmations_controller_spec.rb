require 'rails_helper'

describe ConfirmationsController do
  context "after_resending_confirmation_instructions_path_for" do
    it "should redirect to root url after confirmation" do
      expect(controller.send(:after_confirmation_path_for, :user, create(:user))).to eq("/")
    end
  end
end
