# == Schema Information
#
# Table name: cover_images
#
#  id                       :integer          not null, primary key
#  cover_photo_file_name    :string(255)
#  cover_photo_content_type :string(255)
#  cover_photo_file_size    :integer
#  cover_photo_updated_at   :datetime
#  article_id               :integer
#  preview_image            :boolean          default(FALSE)
#
# Indexes
#
#  index_cover_images_on_article_id  (article_id)
#

require 'rails_helper'

RSpec.describe CoverImage, type: :model do
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
