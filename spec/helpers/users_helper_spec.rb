require 'rails_helper'

RSpec.describe UsersHelper do
  context 'error_message_for_email' do
    it 'should only user errors' do
      user = User.new
      user.valid?

      expect(helper.error_message_for_email(user)).to eq(["Email can't be blank",
                                                          "Password can't be blank",
                                                          'Password should include at least one of the following characters: one letter, one numeral and one special character.',
                                                          "First name can't be blank",
                                                          "Last name can't be blank"])
    end

    it 'should only show email not unique error' do
      create(:user, email: 'valid@example.com')
      user = User.new(email: 'valid@example.com')
      user.valid?

      expect(helper.error_message_for_email(user)).to eq(["Email has already been used to register an account. To retrieve your password for this account, click on <a href='/users/password/new'> forgot your password </a> or <a href='/users/sign_in'> sign in here </a> "])
    end
  end
end
