require 'elasticsearch/model'
class Article < ActiveRecord::Base
  include Elasticsearch::Model
  belongs_to :user
  has_many :article_tags
  has_many :tags, through: :article_tags
  has_many :article_categories
  has_many :categories, through: :article_categories
  attr_accessor :tag_list

  def tag_list
    tags.collect(&:name).join(",")
  end

  def tag_list=(tag_names_string)
    tag_names_array = tag_names_string.split(",")
    article_tags.destroy_all
    tags << tag_names_array.collect { |name| Tag.find_or_initialize_by(name: name) }
  end

  def as_indexed_json(options={})
    self.as_json(
        only: [:id, :title, :content],
        include: {tags: {only: :name}
        })
  end
end
