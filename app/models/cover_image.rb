class CoverImage < ActiveRecord::Base
  belongs_to :article
  has_attached_file :cover_photo, styles: { medium: "758x350!", thumb: "77x77!" }, default_url: "z_:style.png",
                    storage: :s3,
                    s3_credentials: Proc.new{|a| a.instance.s3_credentials}
  validates_attachment_content_type :cover_photo, content_type:  ['image/jpeg', 'image/png', 'image/jpg']
  validates_attachment_size :cover_photo, in: 0..2.megabytes

  def s3_credentials
    s3_hash = YAML.load_file('./config/aws.yml')[Rails.env].with_indifferent_access
    s3_key_hash = s3_hash.slice(:access_key_id, :secret_access_key)
    s3_key_hash.each {|k, v| s3_key_hash[k]=eval(v)}.merge!({bucket: s3_hash[:cover_image_bucket]})
  end
end