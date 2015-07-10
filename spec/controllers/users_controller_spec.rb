require 'rails_helper'

describe UsersController do
  describe "change_email" do
    it "should update valid email" do
      user = create(:user, uid: "uid001", provider: "facebook", email: "")
      sign_in user
      email = "email@valid.com"
      patch :change_email, id: user.id, registered_user: {email: email}

      expect(user.reload.email).to eq(email)
      expect(response).to redirect_to(root_path)
    end

    it "should update valid email based on user type" do
      user = create(:editor, uid: "uid001", provider: "facebook", email: "")
      sign_in user
      email = "email@valid.com"
      patch :change_email, id: user.id, editor: {email: email}

      expect(user.reload.email).to eq(email)
      expect(response).to redirect_to(root_path)
    end

    it "should return error response if email is not unique" do
      email = "email@valid.com"
      user1 = create(:user, uid: "uid001", provider: "facebook", email: email)
      user2 = create(:user, uid: "uid001", provider: "facebook", email: nil)
      sign_in user2
      patch :change_email, id: user2.id, registered_user: {email: email}

      expect(user2.reload.email).to be_nil
      expect(response).to render_template("change_email_form")
    end

    it "should return error response if email is empty" do
      user = create(:user, uid: "uid001", provider: "facebook", email: "")
      sign_in user
      patch :change_email, id: user.id, registered_user: {email: ""}

      expect(response).to render_template("change_email_form")
    end
  end

  describe "edit" do
    it "should set the user" do
      user = create(:user, uid: "uid001", provider: "facebook", email: "")
      sign_in user
      get :change_email_form, id: user.id

      expect(assigns[:user].id).to eq(user.id)
      expect(response).to render_template("change_email_form")
    end
  end

  context "update" do
    it "should update registered_user to editor" do
      admin = create(:administrator)
      sign_in admin
      user = create(:user)
      mailer = double("mailer")
      expect(TypeChangeNotifier).to receive(:change_type_to_editor_mail).with(user.email, user.full_name, User::Roles::EDITOR).and_return(mailer)
      expect(mailer).to receive(:deliver_later)
      patch :update, registered_user: { type: User::Roles::EDITOR }, id: user.id

      expect(Editor.find(user.id)).to be_present
    end

    it "should update editor to admin" do
      admin = create(:administrator)
      sign_in admin
      editor = create(:editor)
      mailer = double("mailer")
      expect(TypeChangeNotifier).to receive(:change_type_to_administrator_mail).with(editor.email, editor.full_name, User::Roles::ADMINISTRATOR).and_return(mailer)
      expect(mailer).to receive(:deliver_later)
      patch :update, editor: { type: User::Roles::ADMINISTRATOR }, id: editor.id

      expect(User.find(editor.id).type).to eq(User::Roles::ADMINISTRATOR)
    end

    it "should update admin to registered_user" do
      admin = create(:administrator)
      sign_in admin
      administrator = create(:administrator)
      mailer = double("mailer")
      expect(TypeChangeNotifier).to receive(:change_type_to_registered_user_mail).with(administrator.email, administrator.full_name, User::Roles::REGISTERED_USER).and_return(mailer)
      expect(mailer).to receive(:deliver_later)
      patch :update, administrator: { type: User::Roles::REGISTERED_USER }, id: administrator.id

      expect(User.find(administrator.id).type).to eq(User::Roles::REGISTERED_USER)
    end
  end
end