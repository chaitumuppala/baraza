require 'rails_helper'

describe User do
  describe "validation" do
    it "should be inavlid if password length is less than 6 characters" do
      user = build(:user, password: "Pa1!")
      expect(user).not_to be_valid
      expect(user.errors.full_messages).to eq(["Password is too short (minimum is 6 characters)"])
    end

    it "should be inavlid if password length is more than 10 characters" do
      expect(build(:user, password: "Pa1!213456675856432456463452")).not_to be_valid
    end

    it "should validate presence" do
      expect(build(:user, password: nil)).not_to be_valid
    end

    it "should validate password and password_confirmation to be equal" do
      expect(build(:user, password: "Password1!", password_confirmation: "Password2!")).not_to be_valid
    end

    it "should validate to include at-least one uppercase letter, lowercase letter, numeral and special character" do
      expect(build(:user, password: "Password1")).not_to be_valid
      expect(build(:user, password: "PASSWORD1!")).not_to be_valid
      expect(build(:user, password: "Password!")).not_to be_valid
      expect(build(:user, password: "Password1")).not_to be_valid

      expect(build(:user, password: "Password1!")).to be_valid
    end

    it "should return error message if email is not unique" do
      create(:user, email: "again@gm.com")
      invalid_user = build(:user, email: "again@gm.com")
      expect(invalid_user).not_to be_valid
      expect(invalid_user.errors.full_messages).to eq(["Email already has a user associated with it. To retrieve password for the email id click on forgot password"])
    end
  end

  describe "before_create" do
    it "should set type as registeredUser if no type is present" do
      user = User.create(email: "random@gmai.com", password: "Password1!", first_name: "deepthi", last_name: "vinod")
      expect(user.type).to eq(RegisteredUser.name)
    end

    it "should set type as registeredUser if type is empty" do
      user = User.create(email: "random@gmai.com", password: "Password1!", first_name: "deepthi", last_name: "vinod", type: "")
      expect(user.type).to eq(RegisteredUser.name)
    end

    it "should use the provided type" do
      user = User.create(email: "random@gmai.com", password: "Password1!", first_name: "deepthi", last_name: "vinod", type: Administrator.name)
      expect(user.type).to eq(Administrator.name)
    end
  end

  describe "skip validation" do
    it "should skip email validation for users associated to providers" do
      expect {
        create(:user, uid: "uid001", provider: "facebook", email: nil)
      }.to change { User.count }.by(1)
    end

    it "should skip password validation for users associated to providers" do
      expect {
        create(:user, uid: "uid001", provider: "facebook", password: nil, password_confirmation: nil)
      }.to change { User.count }.by(1)
    end

    it "should not skip for regular users" do
      expect(build(:user, email: nil)).not_to be_valid
    end
  end

  describe "GenderCategory" do
    context "values" do
      it "should return all values of gender category" do
        expect(User::GenderCategory.values).to eq(["M", "F", "Other"])
      end
    end
  end

  context "administrator?" do
    it "should return true for administrator" do
      expect(create(:administrator).administrator?).to eq(true)
    end

    it "should return false for others" do
      expect(create(:editor).administrator?).to eq(false)
    end
  end

  context "editor?" do
    it "should return true for editor" do
      expect(create(:editor).editor?).to eq(true)
    end

    it "should return false for others" do
      expect(create(:administrator).editor?).to eq(false)
    end
  end

  context "generate_set_password_token" do
    it 'should return the token for the user' do
      user = create(:user)
      expect(user).to receive(:set_reset_password_token)
      user.generate_set_password_token
    end
  end

  context "full_name" do
    it "should return full_name of user" do
      expect(build(:user, first_name: "first", last_name: "last").full_name).to eq("first last")
    end
  end
end