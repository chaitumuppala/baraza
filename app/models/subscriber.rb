# == Schema Information
#
# Table name: subscribers
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Subscriber < ActiveRecord::Base
  validates :email, uniqueness: { case_sensitive: false, message: 'already subscribed' }, email: { if: proc { |s| s.email.present? } }
end
