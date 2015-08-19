require 'rails_helper'

describe CoverImage do
  context "validation" do
    it { should have_attached_file(:cover_photo) }
    it { should validate_attachment_content_type(:cover_photo).
                    allowing('image/png', 'image/jpeg', 'image/jpg').
                    rejecting('text/plain', 'text/xml', 'image/gif') }
    it { should validate_attachment_size(:cover_photo).
                    less_than(2.megabytes) }
  end

  context "s3_credentials" do
    it "should return the credentials based on the environment" do
      expect(build(:cover_image).s3_credentials).to eq({access_key_id: "test", secret_access_key: "test", bucket: "cover_image_test"}.with_indifferent_access)
    end
  end
end