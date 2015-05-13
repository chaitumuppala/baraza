require 'rails_helper'

describe OmniauthCallbacksController do
  ["facebook", "google_oauth2"].each do |provider|
    context provider do
      it "should create first time user and sign_in the user" do
        request.env.merge!({"omniauth.auth" => OpenStruct.new(uid: 'uid001', provider: provider,
                                                                         info: OpenStruct.new(email: "email@x.com", name: "danny"))})
        get provider.to_sym

        user = User.find_by(uid: 'uid001', provider: provider)
        expect(user).not_to be_nil
        expect(response).to redirect_to("/")
        expect(controller.current_user).not_to be_nil
      end

      it "should only sign_in the user from the second time" do
        user = create(:user, uid: "uid001", provider: provider)
        request.env.merge!({"omniauth.auth" => OpenStruct.new(uid: 'uid001', provider: provider,
                                                                         info: OpenStruct.new(email: "email@x.com", name: "danny"))})
        expect{get provider.to_sym}.to_not change{User.count}

        expect(response).to redirect_to("/")
        expect(controller.current_user).to eq(user)
      end
    end
  end
end