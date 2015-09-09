class Subscriber < ActiveRecord::Base
  validates :email, uniqueness: { case_sensitive: false, message: 'already subscribed' }, email: { if: proc { |s| s.email.present? } }
end
