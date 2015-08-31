require 'rails_helper'

describe Author do
  context "validation" do
    it "should validate presence of email" do
      expect(build(:author, email: nil)).not_to be_valid
    end

    it "should validate presence of full_name" do
      expect(build(:author, full_name: nil)).not_to be_valid
    end

    it "should validate uniqueness of email" do
      create(:author, email: "a@b.com")
      expect(build(:author, email: "a@b.com")).not_to be_valid
    end
  end
end