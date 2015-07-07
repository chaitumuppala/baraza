require "rails_helper"

describe NewsletterMailer do
  context "send_mail" do
    it "should send mail to subscribers" do
      newsletter = create(:newsletter)
      u1, u2, u3 = create_list(:user, 3)
      mailer = NewsletterMailer.send_mail(newsletter)

      expect(mailer.to).to match_array([u1.email, u2.email, u3.email])
      expect(mailer.subject).to eq("Baraza newsletter")
    end
  end
end