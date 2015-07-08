class Article < ActiveRecord::Base
  include Elasticsearch::Model
  belongs_to :user
  has_many :article_tags
  has_many :tags, through: :article_tags
  has_many :article_categories
  has_many :categories, through: :article_categories
  attr_accessor :tag_list
  has_attached_file :cover_image, styles: { medium: "400x310>" }, default_url: "z.png",
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
      indexes :status, index: 'not_analyzed'
      indexes :tags do
        indexes :name, index: 'not_analyzed'
      end
      indexes :categories do
        indexes :name, index: 'not_analyzed'
      end
    end
  end

  after_save do
    Delayed::Job.enqueue(ArticleIndexJob.new(id))
  end

  module Status
    DRAFT = "draft"
    SUBMITTED_FOR_APPROVAL = "submitted for approval"
    PUBLISHED = "published"
  end

  def index_current_document_values
    __elasticsearch__.index_document
  end

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
        only: [:id, :title, :content, :status],
        include: {tags: {only: :name},
                  categories: {only: :name}}
    )
  end

  def self.search_by_all(search_text)
    query = {
        query: {
            match: {
                _all: search_text
            }
        },
        filter: {
            and: [
                {
                    term: {
                        status: Status::PUBLISHED
                    }
                }
            ]
        }
    }.to_json
    response = Article.__elasticsearch__.search query
    response.records.to_a
  end

  ["tag", "category"].each do |criteria|
    define_singleton_method "search_by_#{criteria}" do |search_text|
      query = {
          query: {
              filtered: {
                  query: {
                      match_all: {}
                  },
                  filter: {
                      bool: {
                          must: [
                              {
                                  term: {:"#{criteria.pluralize}.name" => search_text}
                              },
                              {
                                  term: {status: Status::PUBLISHED}
                              }
                          ]
                      }
                  }
              }
          }
      }.to_json
      response = Article.__elasticsearch__.search query
      response.records.to_a
    end
  end

  def s3_credentials
    s3_hash = YAML.load_file('./config/aws.yml')[Rails.env].with_indifferent_access
    s3_hash.slice(:access_key_id, :secret_access_key).merge!({bucket: s3_hash[:cover_image_bucket]})
  end
end