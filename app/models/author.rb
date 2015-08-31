class Author < ActiveRecord::Base
  has_many :article_owners, as: :owner
  has_many :articles, through: :article_owners
  validates_uniqueness_of :email
  # validates :email, presence: true, uniqueness: { case_sensitive: false }
end
