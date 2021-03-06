# == Schema Information
#
# Table name: category_newsletters
#
#  id                     :integer          not null, primary key
#  category_id            :integer
#  newsletter_id          :integer
#  position_in_newsletter :integer
#
# Indexes
#
#  index_category_newsletters_on_category_id    (category_id)
#  index_category_newsletters_on_newsletter_id  (newsletter_id)
#

class CategoryNewsletter < ActiveRecord::Base
  belongs_to :category
  belongs_to :newsletter

  default_scope { order('position_in_newsletter') }
end
