require 'rails_helper'

describe AdminUser do
  describe "send_admin_intro_mail" do
    it "should send mail on creation of admin" do
      mailer = double("mailer")
      expect(AdminWelcomeNotifier).to receive(:welcome).and_return(mailer)
      expect(mailer).to receive(:deliver_now)
      create(:admin_user)
    end
  end
end