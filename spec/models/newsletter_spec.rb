# == Schema Information
#
# Table name: newsletters
#
#  id             :integer          not null, primary key
#  name           :string(255)      not null
#  status         :string(255)      default("draft")
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  date_published :datetime
#

require 'rails_helper'

RSpec.describe Newsletter, type: :model do
  before do
    Newsletter.update_all(status: Newsletter::Status::PUBLISHED)
  end

  context 'eligible_articles' do
    it 'should include categories in order of position_in_newsletter with nil values last' do
      newsletter = create(:newsletter)
      category1 = create(:category, name: 'history')
      category2 = create(:category, name: 'science')
      CategoryNewsletter.create(category: category1, newsletter: newsletter, position_in_newsletter: nil)
      CategoryNewsletter.create(category: category2, newsletter: newsletter, position_in_newsletter: 1)
      article1 = create(:article, title: '123', created_at: 1.month.ago.to_datetime, category_id: category1.id, status: Article::Status::PUBLISHED)
      article2 = create(:article, created_at: Time.current.to_date, category_id: category2.id, status: Article::Status::PUBLISHED)
      expected_result = { category2 => [article2].to_set, category1 => [article1].to_set }

      result = newsletter.reload.eligible_articles_by_category
      expect(result).to eq(expected_result)
      expect(result.keys).to eq([category2, category1])
    end

    it 'should include articles that are not part of any newsletter' do
      newsletter = create(:newsletter)
      category1 = create(:category, name: 'history')
      category2 = create(:category, name: 'science')
      CategoryNewsletter.create(category: category1, newsletter: newsletter, position_in_newsletter: 2)
      CategoryNewsletter.create(category: category2, newsletter: newsletter, position_in_newsletter: 1)
      article1 = create(:article, title: '123', created_at: 1.month.ago.to_datetime, category_id: category1.id, status: Article::Status::PUBLISHED)
      article2 = create(:article, created_at: Time.current.to_date, category_id: category2.id, status: Article::Status::PUBLISHED)
      newsletter.update_attributes(status: Newsletter::Status::PUBLISHED)
      article3 = create(:article, created_at: 1.month.ago.to_datetime, newsletter_id: create(:newsletter).id, category_id: category1.id, status: Article::Status::PUBLISHED)
      expected_result = { category2 => [article2].to_set, category1 => [article1].to_set }

      result = newsletter.reload.eligible_articles_by_category
      expect(result).to eq(expected_result)
    end

    it 'should include articles that are part of this newsletter' do
      newsletter = create(:newsletter)
      category1 = create(:category, name: 'history')
      category2 = create(:category, name: 'science')
      CategoryNewsletter.create(category: category1, newsletter: newsletter)
      CategoryNewsletter.create(category: category2, newsletter: newsletter)
      article1 = create(:article, created_at: 1.month.ago.to_datetime, newsletter_id: newsletter.id, category_id: category1.id, status: Article::Status::PUBLISHED)
      article2 = create(:article, created_at: Time.current.to_date, newsletter_id: newsletter.id, category_id: category2.id, status: Article::Status::PUBLISHED)
      newsletter.update_attributes(status: Newsletter::Status::PUBLISHED)
      article3 = create(:article, created_at: 1.month.ago.to_datetime, newsletter_id: create(:newsletter).id, category_id: category2.id, status: Article::Status::PUBLISHED)
      result_hash = { category1 => [article1].to_set, category2 => [article2].to_set }
      expect(newsletter.eligible_articles_by_category).to eq(result_hash)
    end

    it 'should include articles in order of position_in_newsletter and then newsletter_id' do
      newsletter = create(:newsletter)
      category = create(:category, name: 'science')
      CategoryNewsletter.create(category: category, newsletter: newsletter)
      article1 = create(:article, created_at: Time.current.to_date, category_id: category.id, position_in_newsletter: 1, newsletter_id: nil, status: Article::Status::PUBLISHED)
      article2 = create(:article, created_at: Time.current.to_date, category_id: category.id, position_in_newsletter: 1, newsletter_id: newsletter.id, status: Article::Status::PUBLISHED)

      result = newsletter.reload.eligible_articles_by_category
      expect(result[category].collect(&:id)).to eq([article2.id, article1.id])
    end
  end

  context 'after_create' do
    it 'should associate all categories to the newsletter' do
      category1 = create(:category, name: 'history')
      category2 = create(:category, name: 'science')
      newsletter = create(:newsletter, status: Newsletter::Status::DRAFT)

      expect(newsletter.categories).to eq([category1, category2])
    end
  end

  context 'associated_articles_by_category' do
    it 'should list associated articles by category in order' do
      newsletter = create(:newsletter)
      category1 = create(:category, name: 'history')
      category2 = create(:category, name: 'science')
      CategoryNewsletter.create(category: category1, newsletter: newsletter, position_in_newsletter: 2)
      CategoryNewsletter.create(category: category2, newsletter: newsletter, position_in_newsletter: 1)
      newsletter.update_attributes(status: Newsletter::Status::PUBLISHED)
      article1 = create(:article, created_at: 1.month.ago.to_datetime, newsletter_id: newsletter.id, category_id: category2.id, position_in_newsletter: 2, status: Article::Status::PUBLISHED)
      article2 = create(:article, created_at: Time.current.to_date, newsletter_id: newsletter.id, category_id: category2.id, position_in_newsletter: 1, status: Article::Status::PUBLISHED)
      article3 = create(:article, created_at: 1.month.ago.to_datetime, newsletter_id: create(:newsletter).id, category_id: category1.id, status: Article::Status::PUBLISHED)
      article4 = create(:article, created_at: 1.month.ago.to_datetime, newsletter_id: nil, category_id: category2.id, status: Article::Status::PUBLISHED)
      article5 = create(:article, created_at: Time.current.to_date, newsletter_id: newsletter.id, category_id: category1.id, position_in_newsletter: 1, status: Article::Status::PUBLISHED)
      result_hash = { category2 => [article2, article1].to_set, category1 => [article5].to_set }
      expect(newsletter.associated_articles_by_category).to eq(result_hash)
    end

    it 'should list only those categories with articles' do
      newsletter = create(:newsletter)
      category1 = create(:category, name: 'history')
      category2 = create(:category, name: 'science')
      CategoryNewsletter.create(category: category1, newsletter: newsletter, position_in_newsletter: 2)
      CategoryNewsletter.create(category: category2, newsletter: newsletter, position_in_newsletter: 1)
      article1 = create(:article, newsletter_id: newsletter.id, category_id: category1.id, position_in_newsletter: 2, status: Article::Status::PUBLISHED)
      article2 = create(:article, newsletter_id: newsletter.id, category_id: category1.id, position_in_newsletter: 1, status: Article::Status::PUBLISHED)

      expect(newsletter.associated_articles_by_category).to eq(category1 => [article2, article1].to_set)
    end
  end

  context 'after_save' do
    it 'should set date_published on update and publishing newsletter' do
      newsletter = create(:newsletter, status: Newsletter::Status::DRAFT)
      newsletter.update_attributes(status: Newsletter::Status::PUBLISHED)
      expect(newsletter.date_published.to_date).to eq(Time.current.to_date)
      expect(newsletter.date_published).to be_within(1.minute).of(Time.current)
    end
  end

  context 'validation' do
    it { should validate_presence_of(:name) }

    it 'should allow only one newsletter with draft' do
      n = create(:newsletter, status: Newsletter::Status::DRAFT)
      n.update_attributes(status: Newsletter::Status::PUBLISHED)

      create(:newsletter, status: Newsletter::Status::DRAFT)
      newsletter3 = build(:newsletter, status: Newsletter::Status::DRAFT)

      expect(newsletter3).not_to be_valid
    end
  end
end
