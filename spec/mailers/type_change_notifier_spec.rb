require 'rails_helper'

RSpec.describe TypeChangeNotifier, type: :mailer do
  context "change_type_to_editor_mail" do
    it "should send mail to creator" do
      user = create(:user)
      mailer = TypeChangeNotifier.change_type_to_editor_mail(user.email, user.full_name)

      expect(mailer.to).to eq([user.email])
      expect(mailer.subject).to eq("You have been assigned as an editor on the Pan-African Baraza")
    end
  end

  context "change_type_to_administrator_mail" do
    it "should send mail to creator" do
      user = create(:user)
      mailer = TypeChangeNotifier.change_type_to_administrator_mail(user.email, user.full_name)

      expect(mailer.to).to eq([user.email])
      expect(mailer.subject).to eq("You have been assigned as an admin on the Pan-African Baraza")
    end
  end

  context "change_type_to_registered_user_mail" do
    it "should send mail to creator" do
      user = create(:user)
      mailer = TypeChangeNotifier.change_type_to_registered_user_mail(user.email, user.full_name)

      expect(mailer.to).to eq([user.email])
      expect(mailer.subject).to eq("You have been assigned back to a registered user on the Pan-African Baraza")
    end
  end
end
