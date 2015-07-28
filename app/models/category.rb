class Category < ActiveRecord::Base
  has_many :articles, -> { order('-articles.position_in_newsletter DESC', 'newsletter_id DESC') }
end
