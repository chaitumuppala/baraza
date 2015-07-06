require "rails_helper"

describe ArticleMailer do
  context "notification_to_creator" do
    it "should send mail to creator" do
      user = create(:user)
      article = create(:article)
      mailer = ArticleMailer.notification_to_creator(user, article)

      expect(mailer.to).to eq([user.email])
      expect(mailer.subject).to eq("Your article is received")
    end
  end

  context "notification_to_editors" do
    it "should send mail to editors and administrator" do
      editor1 = create(:editor)
      editor2 = create(:editor)
      admin1 = create(:administrator)
      article = create(:article)
      mailer = ArticleMailer.notification_to_editors(article)

      expect(mailer.to).to match_array([editor1.email, editor2.email, admin1.email])
      expect(mailer.subject).to eq("An article is received")
    end
  end

  context "published_notification_to_creator" do
    it "should send mail to creator" do
      user = create(:user)
      article = create(:article)
      mailer = ArticleMailer.published_notification_to_creator(user, article)

      expect(mailer.to).to eq([user.email])
      expect(mailer.subject).to eq("Your article is published")
    end
  end
end