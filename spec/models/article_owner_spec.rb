# == Schema Information
#
# Table name: article_owners
#
#  id         :integer          not null, primary key
#  article_id :integer
#  owner_id   :integer
#  owner_type :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_article_owners_on_article_id  (article_id)
#

# # == Schema Information
# #
# # Table name: article_owners
# #
# #  id         :integer          not null, primary key
# #  article_id :integer
# #  owner_id   :integer
# #  owner_type :string(255)
# #  created_at :datetime         not null
# #  updated_at :datetime         not null
# #
# # Indexes
# #
# #  index_article_owners_on_article_id  (article_id)
# #
#
# require 'rails_helper'
# 
# RSpec.describe ArticleOwner, type: :model do
#   describe 'Relationships' do
#     it { should belong_to(:article) }
#     it { should belong_to(:owner) }
#   end
#
#   describe 'Validations' do
#     pending "add some examples to (or delete) #{__FILE__}"
#   end
# end
