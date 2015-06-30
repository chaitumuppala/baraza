require 'rails_helper'

describe ApplicationController do
  controller do
    def index
      head :ok
    end
  end

  context 'authenticate' do
    context "user_id" do
      it "should prompt for the password for a valid user_id param" do
        user = create(:user, email: nil, uid: "uid", provider: "facebook")
        sign_in user
        get :index
        expect(response).to redirect_to user_change_email_form_path(user)
      end
    end
  end
end
