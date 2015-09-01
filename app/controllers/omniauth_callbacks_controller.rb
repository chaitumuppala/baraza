class OmniauthCallbacksController < ApplicationController
  def self.define_provider_callback(provider)
    class_eval %Q{
      def #{provider}
        auth = request.env["omniauth.auth"]
        user = User.find_by(uid: auth.uid, provider: auth.provider)
        if user.nil?
          user = User.create(uid: auth.uid, provider: auth.provider, first_name: auth.info.first_name, last_name: auth.info.last_name, password: User::PASSWORD_SUBSTRING + SecureRandom.hex[0..5])
          user.skip_confirmation!
        else
          user.confirm!
        end
        sign_in_and_redirect user
      end
    }
  end

  [:google_oauth2, :facebook].each do |provider|
    define_provider_callback provider
  end
end
