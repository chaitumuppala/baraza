class ArticleMailer < ApplicationMailer
  def notification_to_creator(recipient, article)
    @user = recipient
    @article = article
    mail(to: recipient.email, subject: "Your article is received")
  end

  def notification_to_editors(article)
    @article = article
    mail(to: Editor.pluck(:email) + Administrator.pluck(:email), subject: "An article is received")
  end

  def published_notification_to_creator(recipient, article)
    @user = recipient
    @article = article
    mail(to: recipient.email, subject: "Your article is published")
  end
end