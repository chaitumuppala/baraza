# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Category, type: :model do
  context "articles" do
    it "should include articles in order of position_in_newsletter" do
      category = create(:category, name: "science")
      article1 = create(:article, title: "123", created_at: 1.month.ago.to_datetime, category_id: category.id, position_in_newsletter: 2, status: Article::Status::PUBLISHED)
      article2 = create(:article, created_at: Date.today, category_id: category.id, position_in_newsletter: 1, status: Article::Status::PUBLISHED)
      article3 = create(:article, created_at: Date.today, category_id: category.id, position_in_newsletter: nil, status: Article::Status::PUBLISHED)

      result = category.articles
      expect(result.collect(&:id)).to eq([article2.id, article1.id, article3.id])
    end
  end
end
