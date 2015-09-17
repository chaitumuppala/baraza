# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# # == Schema Information
# #
# # Table name: categories
# #
# #  id         :integer          not null, primary key
# #  name       :string(255)
# #  created_at :datetime         not null
# #  updated_at :datetime         not null
# #

require 'rails_helper'

RSpec.describe Category do
  it { should have_many(:articles) }

# This needs to change. The test is pointless right now since position_in_newsletter sits in article

#   context 'articles' do
#     it 'should include articles in order of position_in_newsletter' do
#       category = create(:category, name: 'science')
#       article1 = create(:article, category: category, position_in_newsletter: 2, status: Article::Status::PUBLISHED)
#       article2 = create(:article, category: category, position_in_newsletter: 1, status: Article::Status::PUBLISHED)
#       article3 = create(:article, category: category, position_in_newsletter: nil, status: Article::Status::PUBLISHED)
# 
#       result = category.articles
#       expect(result.collect(&:id)).to eq([article2.id, article1.id, article3.id])
#     end
#   end
end
