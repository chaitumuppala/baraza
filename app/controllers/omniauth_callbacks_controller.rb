class OmniauthCallbacksController < ApplicationController
  def self.define_provider_callback(provider)
    class_eval %Q{
      def #{provider}
        auth = request.env["omniauth.auth"]
        user = User.find_by(uid: auth.uid, provider: auth.provider)
        if user.nil?
          user = User.create(uid: auth.uid, provider: auth.provider)
          user.skip_confirmation!
        end
        sign_in_and_redirect user
      end
    }
  end

  [:google_oauth2, :facebook].each do |provider|
    define_provider_callback provider
  end
end