require 'rails_helper'

describe Newsletter do
  # draft, approved, published
  context "eligible_articles" do
    it "should include articles that are not part of any newsletter" do
      newsletter = create(:newsletter)
      category1 = create(:category, name: "history")
      category2 = create(:category, name: "science")
      article1 = create(:article, title: "123", created_at: 1.month.ago.to_datetime, category_ids: [category1.id, category2.id])
      article2 = create(:article, created_at: Date.today, category_ids: [category2.id])
      article3 = create(:article, created_at: 1.month.ago.to_datetime, newsletter_id: create(:newsletter).id, category_ids: [category1.id])
      result_hash = { category1.name => [article1].to_set, category2.name => [article2].to_set}

      expect(newsletter.eligible_articles_by_category).to eq(result_hash)
    end

    it "should include articles that are part of this newsletter" do
      newsletter = create(:newsletter)
      category1 = create(:category, name: "history")
      category2 = create(:category, name: "science")
      article1 = create(:article, created_at: 1.month.ago.to_datetime, newsletter_id: newsletter.id, category_ids: [category1.id, category2.id])
      article2 = create(:article, created_at: Date.today, newsletter_id: newsletter.id, category_ids: [category2.id])
      article3 = create(:article, created_at: 1.month.ago.to_datetime, newsletter_id: create(:newsletter).id, category_ids: [category1.id, category2.id])
      result_hash = { category1.name => [article1].to_set, category2.name => [article2].to_set}
      expect(newsletter.eligible_articles_by_category).to eq(result_hash)
    end
  end
end
