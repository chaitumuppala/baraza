require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  %w(facebook google_oauth2).each do |provider|
    context provider do
      it 'should create first time user and sign_in the user' do
        request.env.merge!('omniauth.auth' => OpenStruct.new(uid: 'uid001', provider: provider,
                                                             info: OpenStruct.new(email: 'email@x.com', first_name: 'karthik', last_name: 'sr')))
        get provider.to_sym

        user = User.find_by(uid: 'uid001', provider: provider)
        expect(user).not_to be_nil
        expect(user.first_name).to eq('karthik')
        expect(user.last_name).to eq('sr')
        expect(response).to redirect_to(root_path)
        expect(controller.current_user).not_to be_nil
      end

      it 'should only sign_in the user from the second time' do
        user = create(:user, uid: 'uid001', provider: provider)
        request.env.merge!('omniauth.auth' => OpenStruct.new(uid: 'uid001', provider: provider,
                                                             info: OpenStruct.new(email: 'email@x.com', name: 'danny')))
        expect { get provider.to_sym }.to_not change { User.count }

        expect(response).to redirect_to('/')
        expect(controller.current_user.id).to eq(user.id)
      end
    end
  end
end
