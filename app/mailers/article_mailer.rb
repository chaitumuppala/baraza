  class ArticleMailer < ApplicationMailer
  def notification_to_owner(recipient, article)
    @user = recipient
    @article = article
    mail(to: recipient.email, subject: "Thank you for your submission")
  end

  def notification_to_editors(article)
    @article = article
    mail(to: Editor.pluck(:email) + Administrator.pluck(:email), subject: "Submission for review by #{@article.owners.first.full_name}: #{@article.title}")
  end

  def published_notification_to_owner(recipient, article)
    @user = recipient
    @article = article
    mail(to: recipient.email, subject: "Your article has been published")
  end

  def published_notification_to_editors(article)
    @article = article
    mail(to: Editor.pluck(:email) + Administrator.pluck(:email), subject: "#{@article.title} has been published")
  end
end
