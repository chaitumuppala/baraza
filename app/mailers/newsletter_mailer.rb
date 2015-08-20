class NewsletterMailer < ApplicationMailer
  helper ApplicationHelper
  def send_mail(newsletter)
    @newsletter = newsletter
    mail(bcc: Subscriber.all.collect(&:email), subject: "Baraza eMagazine")
  end
end