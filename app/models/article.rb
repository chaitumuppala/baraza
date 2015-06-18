class Article < ActiveRecord::Base
  include Elasticsearch::Model
  belongs_to :user
  has_many :article_tags
  has_many :tags, through: :article_tags
  has_many :article_categories
  has_many :categories, through: :article_categories
  attr_accessor :tag_list
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

  def update_index_of_doc
    self.__elasticsearch__.index_document
  end

  def tag_list
    tags.collect(&:name).join(",")
  end

  def tag_list=(tag_names_string)
    existing_tag_names = tags.pluck :name
    modified_tag_names = tag_names_string.split(",")
    tag_names_to_be_added = modified_tag_names - existing_tag_names
    tag_names_to_be_removed = existing_tag_names - modified_tag_names
    tags << tag_names_to_be_added.collect { |name| Tag.find_or_initialize_by(name: name) }
    article_tags.includes(:tag).destroy_all(tags: {name: tag_names_to_be_removed})
  end

  def as_indexed_json(options={})
    self.as_json(
        only: [:id, :title, :content],
        include: {tags: {only: :name},
                  categories: {only: :name}}
    )
  end

  ["tag", "category"].each do |criteria|
    define_singleton_method "search_by_#{criteria}" do |tag_name|
      query = Jbuilder.encode do |json|
        json.query do
          json.filtered do
            json.query do
              json.set!("match_all", {})
            end
            json.filter do
              json.term do
                json.set!("#{criteria.pluralize}.name", tag_name)
              end
            end
          end
        end
      end
      response = Article.__elasticsearch__.search query
      response.results
    end
  end
end