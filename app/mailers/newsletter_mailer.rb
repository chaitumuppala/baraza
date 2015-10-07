class NewsletterMailer < ApplicationMailer
  helper ApplicationHelper
  def send_mail(newsletter)
    @newsletter = newsletter
    mail(bcc: Subscriber.all.collect(&:email), subject: 'Baraza eMagazine')
  end

  def subscribtion_signup(email)
    mail(to: email, subject: 'Baraza eMagazine subscription')
  end

end
