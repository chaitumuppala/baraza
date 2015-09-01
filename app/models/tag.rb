# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# TODO: Vijay: Data integrity mandates that the db has constraints like non-nullable column, foreign key constraints, etc
class Tag < ActiveRecord::Base
  # TODO: Vijay: Should this have unique name?
  # uniqueness: { case_sensitive: false },
  validates :name, presence: true
end
