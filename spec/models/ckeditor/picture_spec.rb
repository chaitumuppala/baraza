require 'rails_helper'

describe Ckeditor::Picture do
  context "s3_credentials" do
    it "should return the credentials based on the environment" do
      expect(Ckeditor::Picture.new.s3_credentials).to eq({access_key_id: "test", secret_access_key: "test", bucket: "ckeditor_image_test"}.with_indifferent_access)
    end
  end
end