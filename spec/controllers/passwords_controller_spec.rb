require 'rails_helper'

RSpec.describe PasswordsController, type: :controller do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  context 'edit' do
    it 'should render edit for valid token' do
      user = create(:user)
      token = user.send_reset_password_instructions
      get :edit, reset_password_token: token

      expect(controller.resource).to be_a_new(User)
      expect(controller.resource.reset_password_token).to eq(token)
      expect(response).to render_template('edit')
      expect(flash[:error]).to be_nil
    end

    it 'should render edit with error for invalid token' do
      user = create(:user)
      user.send_reset_password_instructions
      get :edit, reset_password_token: 'invalid token'

      expect(response).to render_template('edit')
      expect(flash[:error]).to eq('Reset password token is invalid')
    end
  end
end
