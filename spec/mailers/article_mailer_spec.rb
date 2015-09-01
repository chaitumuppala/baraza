require "rails_helper"

RSpec.describe ArticleMailer, type: :mailer do
  before(:each) do
    User.delete_all
  end

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
      editor1 = create(:editor, first_name: "f1", last_name: "l1")
      editor2 = create(:editor, first_name: "f2", last_name: "l2")
      admin1 = create(:administrator, first_name: "f3", last_name: "l3")
      article = create(:article, title: "foo bar")
      article.users << create(:user, first_name: "f4", last_name: "l4")
      mailer = ArticleMailer.notification_to_editors(article)

      expect(mailer.to).to match_array([editor1.email, editor2.email, admin1.email])
      expect(mailer.subject).to eq("Submission for review by f4 l4: foo bar")
    end
  end

  context "published_notification_to_editors" do
    it "should send mail to editors and administrator" do
      editor1 = create(:editor)
      editor2 = create(:editor)
      admin1 = create(:administrator)
      article = create(:article, title: 'unite all')
      article.system_users << create(:author)
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
