  class ArticleMailer < ApplicationMailer
  def notification_to_creator(recipient, article)
    @user = recipient
    @article = article
    mail(to: recipient.email, subject: "Thank you for your submission")
  end

  def notification_to_editors(article)
    @article = article
    # TODO: send mail to author
    mail(to: Editor.pluck(:email) + Administrator.pluck(:email), subject: "Submission for review by author: #{@article.title}")
  end

  def published_notification_to_creator(recipient, article)
    @user = recipient
    @article = article
    mail(to: recipient.email, subject: "Your article has been published")
  end

  def published_notification_to_editors(article)
    @article = article
    mail(to: Editor.pluck(:email) + Administrator.pluck(:email), subject: "#{@article.title} has been published")
  end
end
