class Newsletter < ActiveRecord::Base
  has_many :articles
  accepts_nested_attributes_for :articles
end
