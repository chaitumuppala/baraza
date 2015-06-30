class CategoryNewsletter < ActiveRecord::Base
  belongs_to :category
  belongs_to :newsletter
end