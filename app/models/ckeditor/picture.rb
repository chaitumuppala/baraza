class Ckeditor::Picture < Ckeditor::Asset
  has_attached_file :data,
                    storage: :s3,
                    s3_credentials: Proc.new{|a| a.instance.s3_credentials},
                    styles: { content: '800>', thumb: '118x100#' }

  validates_attachment_presence :data
  validates_attachment_size :data, :less_than => 2.megabytes
  validates_attachment_content_type :data, :content_type => /\Aimage/

  def url_content
    url(:content)
  end

  def s3_credentials
    s3_hash = YAML.load_file('./config/aws.yml')[Rails.env].with_indifferent_access
    s3_key_hash = s3_hash.slice(:access_key_id, :secret_access_key)
    s3_key_hash.each {|k, v| s3_key_hash[k]=eval(v)}.merge!({bucket: s3_hash[:ckeditor_image_bucket]})
  end
end
