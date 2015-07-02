class Article < ActiveRecord::Base
  include Elasticsearch::Model
  belongs_to :user
  has_many :article_tags
  has_many :tags, through: :article_tags
  has_many :article_categories
  has_many :categories, through: :article_categories
  attr_accessor :tag_list
  has_attached_file :cover_image, styles: { medium: "400x310>" }, default_url: "africa.jpg",
                    storage: :s3,
                    s3_credentials: Proc.new{|a| a.instance.s3_credentials}
  validates_attachment_content_type :cover_image, content_type:  ['image/jpeg', 'image/png', 'image/jpg']
  validates_attachment_size :cover_image, in: 0..2.megabytes
  validates_presence_of :title, :content, :categories
  index_name    "articles_#{Rails.env}"
  settings do
    mapping do
      indexes :title, analyzer: 'snowball'
      indexes :content, analyzer: 'snowball'
      indexes :tags do
        indexes :name, index: 'not_analyzed'
      end
      indexes :categories do
        indexes :name, index: 'not_analyzed'
      end
    end
  end

  after_save do
    index_current_document_values
  end

  module Status
    DRAFT = "draft"
    SUBMITTED_FOR_APPROVAL = "submitted for approval"
    PUBLISHED = "published"
  end

  def index_current_document_values
    __elasticsearch__.index_document
  end

  handle_asynchronously :index_current_document_values

  def tag_list
    tags.collect(&:name).join(",")
  end

  def tag_list=(tag_names_string)
    tag_names_array = tag_names_string.split(",")
    tags.destroy_all
    tags << tag_names_array.collect { |name| Tag.find_or_initialize_by(name: name) }
  end

  def as_indexed_json(options={})
    self.as_json(
        only: [:id, :title, :content],
        include: {tags: {only: :name},
                  categories: {only: :name}}
    )
  end

  def self.search_by_all(search_text)
    query = Jbuilder.encode do |json|
      json.query do
        json.match do
          json.set!("_all", search_text)
        end
      end
    end
    response = Article.__elasticsearch__.search query
    response.records.to_a
  end

  ["tag", "category"].each do |criteria|
    define_singleton_method "search_by_#{criteria}" do |search_text|
      query = Jbuilder.encode do |json|
        json.query do
          json.filtered do
            json.query do
              json.set!("match_all", {})
            end
            json.filter do
              json.term do
                json.set!("#{criteria.pluralize}.name", search_text)
              end
            end
          end
        end
      end
      response = Article.__elasticsearch__.search query
      response.records.to_a
    end
  end

  def s3_credentials
    s3_hash = YAML.load_file('./config/aws.yml')[Rails.env].with_indifferent_access
    s3_hash.slice(:access_key_id, :secret_access_key).merge!({bucket: s3_hash[:cover_image_bucket]})
  end
end