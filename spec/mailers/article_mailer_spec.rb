require "rails_helper"

describe ArticleMailer do
  context "notification_to_creator" do
    it "should send mail to creator" do
      creator = create(:creator)
      article = create(:article)
      mailer = ArticleMailer.notification_to_owner(creator, article)

      expect(mailer.to).to eq([creator.email])
      expect(mailer.subject).to eq("Thank you for your submission")
    end
  end

  context "notification_to_editors" do
    it "should send mail to editors and administrator" do
      editor1 = create(:editor)
      editor2 = create(:editor)
      admin1 = create(:administrator)
      article = create(:article)
      article.users << create(:user)
      mailer = ArticleMailer.notification_to_editors(article)

      expect(mailer.to).to match_array([editor1.email, editor2.email, admin1.email])
      expect(mailer.subject).to eq("Submission for review by Patrick Jane: unite all")
    end
  end

  context "published_notification_to_editors" do
    it "should send mail to editors and administrator" do
      editor1 = create(:editor)
      editor2 = create(:editor)
      admin1 = create(:administrator)
      article = create(:article)
      mailer = ArticleMailer.published_notification_to_editors(article)

      expect(mailer.to).to match_array([editor1.email, editor2.email, admin1.email])
      expect(mailer.subject).to eq("unite all has been published")
    end
  end

  context "published_notification_to_creator" do
    it "should send mail to creator" do
      creator = create(:creator)
      article = create(:article)
      mailer = ArticleMailer.published_notification_to_owner(creator, article)

      expect(mailer.to).to eq([creator.email])
      expect(mailer.subject).to eq("Your article has been published")
    end
  end
end