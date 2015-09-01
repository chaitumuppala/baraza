require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      head :ok
    end
  end

  context 'authenticate' do
    context 'user_id' do
      it 'should prompt for the password for a valid user_id param' do
        user = create(:user, email: nil, uid: 'uid', provider: 'facebook')
        test_user_sign_in user

        get :index

        expect(response).to redirect_to change_email_form_user_path(user)
      end
    end
  end

  context 'application_meta_tag' do
    it 'should set_meta_tag before every action' do
      expect(controller).to receive(:set_meta_tags).with(site: 'Baraza',
                                                         title: 'Baraza')

      get :index
    end
  end
end
