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

# TODO: Vijay: Data integrity mandates that the db has constraints like non-nullable column, foreign key constraints, etc
class Ckeditor::Picture < Ckeditor::Asset
  has_attached_file :data,
                    storage:        :s3,
                    s3_credentials: proc { |a| a.instance.s3_credentials },
                    styles:         { content: '800>', thumb: '118x100#' }

  validates_attachment_presence :data
  validates_attachment_size :data, less_than: 2.megabytes
  validates_attachment_content_type :data, content_type: /\Aimage/

  def url_content
    url(:content)
  end

  def s3_credentials
    s3_hash = YAML.load_file('./config/aws.yml')[Rails.env].with_indifferent_access
    s3_key_hash = s3_hash.slice(:access_key_id, :secret_access_key)
    s3_key_hash.each { |k, v| s3_key_hash[k] = eval(v) }.merge!(bucket: s3_hash[:ckeditor_image_bucket])
  end
end
