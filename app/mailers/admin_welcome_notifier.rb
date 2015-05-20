class AdminWelcomeNotifier < ApplicationMailer
  def welcome(recipient)
    @user = recipient
    mail(to: recipient.email)
  end
end
