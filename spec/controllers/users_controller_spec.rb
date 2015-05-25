require 'rails_helper'

describe UsersController do
  describe "update" do
    it "should update valid email" do
      user = create(:user, uid: "uid001", provider: "facebook", email: "")
      sign_in user
      email = "email@valid.com"
      patch :update, id: user.id, registered_user: {email: email}

      expect(user.reload.email).to eq(email)
      expect(response).to redirect_to(root_path)
    end

    it "should return error response if email is not unique" do
      email = "email@valid.com"
      user1 = create(:user, uid: "uid001", provider: "facebook", email: email)
      user2 = create(:user, uid: "uid001", provider: "facebook", email: nil)
      sign_in user2
      patch :update, id: user2.id, registered_user: {email: email}

      expect(user2.reload.email).to be_nil
      expect(response).to render_template("edit")
      end

    it "should return error response if email is empty" do
      user = create(:user, uid: "uid001", provider: "facebook", email: "")
      sign_in user
      patch :update, id: user.id, registered_user: {email: ""}

      expect(response).to render_template("edit")
    end
  end

  describe "edit" do
    it "should set the user" do
      user = create(:user, uid: "uid001", provider: "facebook", email: "")
      sign_in user
      get :edit, id: user.id

      expect(assigns[:user].id).to eq(user.id)
      expect(response).to render_template("edit")
    end
  end
end