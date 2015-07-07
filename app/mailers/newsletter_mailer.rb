class NewsletterMailer < ApplicationMailer
  def send_mail(newsletter)
    @newsletter = newsletter
    mail(to: RegisteredUser.all.collect(&:email), subject: "Baraza newsletter")
  end
end