# == Schema Information
#
# Table name: authors
#
#  id         :integer          not null, primary key
#  full_name  :string(255)      not null
#  email      :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# TODO: Vijay: Data integrity mandates that the db has constraints like non-nullable column, foreign key constraints, etc
class Author < ActiveRecord::Base
  has_many :article_owners, as: :owner
  has_many :articles, through: :article_owners

  validates :email, uniqueness: { case_sensitive: false }, presence: true
  validates :full_name, presence: true
end
