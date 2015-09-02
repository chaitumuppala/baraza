require 'rails_helper'

RSpec.describe NewsletterMailer, type: :mailer do
  context 'send_mail' do
    it 'should send mail to subscribers' do
      newsletter = build(:newsletter)
      s1 = Subscriber.create(email: 'e1@e.com')
      s2 = Subscriber.create(email: 'e2@e.com')
      mailer = NewsletterMailer.send_mail(newsletter)

      expect(mailer.bcc).to match_array(['e1@e.com', 'e2@e.com'])
      expect(mailer.subject).to eq('Baraza eMagazine')
    end
  end
end
