require 'rails_helper'

describe User do
  describe "validation" do
    it "should be inavlid if password length is less than 6 characters" do
      expect(build(:user, password: "pass")).not_to be_valid
    end

    it "should be inavlid if password length is more than 10 characters" do
      expect(build(:user, password: "*"*15)).not_to be_valid
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
  end
end