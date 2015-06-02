require 'rails_helper'

describe Administrator do
  context "before_validation" do
    it "should set a random password" do
      admin = create(:administrator)
      expect(admin.reload.id).not_to be_nil
    end
  end
  context "before_create" do
    it "should confirm the administrator" do
      expect(create(:administrator).confirmed_at).not_to be_nil
    end
  end

  context "after_create" do
    it "should send welcome mail" do
      admin = build(:administrator)
      mailer = double("mailer")
      expect(AdminWelcomeNotifier).to receive(:welcome).with(admin).and_return(mailer)
      expect(mailer).to receive(:deliver_now)
      admin.save
    end
  end
end