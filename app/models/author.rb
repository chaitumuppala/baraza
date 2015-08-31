class Author < ActiveRecord::Base
  has_many :article_owners, as: :owner
  has_many :articles, through: :article_owners
  validates :email, uniqueness: true, presence: true
  validates :full_name, presence: true
end
