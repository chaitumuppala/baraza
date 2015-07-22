class CategoryNewsletter < ActiveRecord::Base
  belongs_to :category
  belongs_to :newsletter

  default_scope { order('-position_in_newsletter DESC') }
end