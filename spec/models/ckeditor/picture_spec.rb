# == Schema Information
#
# Table name: ckeditor_assets
#
#  id                :integer          not null, primary key
#  data_file_name    :string(255)      not null
#  data_content_type :string(255)
#  data_file_size    :integer
#  assetable_id      :integer
#  assetable_type    :string(30)
#  type              :string(30)
#  width             :integer
#  height            :integer
#  created_at        :datetime
#  updated_at        :datetime
#
# Indexes
#
#  idx_ckeditor_assetable       (assetable_type,assetable_id)
#  idx_ckeditor_assetable_type  (assetable_type,type,assetable_id)
#

require 'rails_helper'

RSpec.describe Ckeditor::Picture do
  context "s3_credentials" do
    it "should return the credentials based on the environment" do
      expect(Ckeditor::Picture.new.s3_credentials).to eq({access_key_id: "test", secret_access_key: "test", bucket: "ckeditor_image_test"}.with_indifferent_access)
    end
  end
end
