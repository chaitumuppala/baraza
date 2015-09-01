# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# TODO: Vijay: Data integrity mandates that the db has constraints like non-nullable column, foreign key constraints, etc
class Category < ActiveRecord::Base
  has_many :articles, -> { order('-articles.position_in_newsletter DESC'.freeze, 'newsletter_id DESC'.freeze) }
end
