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

# TODO: Vijay: Data integrity mandates that the db has constraints like non-nullable column, foreign key constraints, etc
class CoverImage < ActiveRecord::Base
  belongs_to :article
  has_attached_file :cover_photo, styles: { medium: "758x350!".freeze, thumb: "77x77!".freeze }, default_url: "z_:style.png".freeze,
                    storage: :s3,
                    s3_credentials: Proc.new{|a| a.instance.s3_credentials}
  validates_attachment_content_type :cover_photo, content_type: ['image/jpeg'.freeze, 'image/png'.freeze, 'image/jpg'.freeze]
  validates_attachment_size :cover_photo, in: 0..2.megabytes

  def s3_credentials
    s3_hash = YAML.load_file('./config/aws.yml'.freeze)[Rails.env].with_indifferent_access
    s3_key_hash = s3_hash.slice(:access_key_id, :secret_access_key)
    s3_key_hash.each {|k, v| s3_key_hash[k]=eval(v)}.merge!({bucket: s3_hash[:cover_image_bucket]})
  end
end
