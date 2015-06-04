class Article < ActiveRecord::Base
  belongs_to :user
  has_many :article_tags
  has_many :tags, through: :article_tags
  attr_accessor :tag_list

  def tag_list
    tags.collect(&:name).join(",")
  end

  def tag_list=(tag_names_string)
    tag_names_array = tag_names_string.split(",")
    article_tags.destroy_all
    tags << tag_names_array.collect { |name| Tag.find_or_initialize_by(name: name) }
  end
end
