# == Schema Information
#
# Table name: subscribers
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# TODO: Vijay: Data integrity mandates that the db has constraints like non-nullable column, foreign key constraints, etc
class Subscriber < ActiveRecord::Base
  validates :email, uniqueness: { case_sensitive: false }
end
