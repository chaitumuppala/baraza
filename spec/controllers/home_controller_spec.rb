require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  it "should set blocks without home_page_order with recently published articles " do
    article1 = create(:article, home_page_order: 5, status: Article::Status::PUBLISHED)
    article2 = create(:article, home_page_order: 1, status: Article::Status::PUBLISHED)
    article3 = create(:article, home_page_order: 2, status: Article::Status::PUBLISHED)
    article4 = create(:article, home_page_order: nil, status: Article::Status::PUBLISHED)
    article5 = create(:article, home_page_order: nil, status: Article::Status::PUBLISHED)
    article1.update_attributes(date_published: Date.yesterday)
    article2.update_attributes(date_published: 5.days.ago)
    article3.update_attributes(date_published: 2.days.ago)
    article4.update_attributes(date_published: Date.today)
    create(:article, home_page_order: 4, status: Article::Status::SUBMITTED_FOR_APPROVAL)
    create(:article, home_page_order: nil)

    get :index

    expected_result = { 1 => article2, 2 => article3, 3 => article5, 4 => article4, 5 => article1, 6 => nil, 7 => nil, 8 => nil }
    expect(assigns[:published_articles]).to eq([article5, article4, article1, article3, article2])
    expect(assigns[:articles_with_order]).to eq(expected_result)
  end

  it "should by default show recently published articles if no article has home_page_order" do
    article1 = create(:article, status: Article::Status::PUBLISHED)
    article2 = create(:article, status: Article::Status::PUBLISHED)
    article3 = create(:article, status: Article::Status::PUBLISHED)
    article4 = create(:article, status: Article::Status::PUBLISHED)
    article5 = create(:article, status: Article::Status::PUBLISHED)
    article1.update_attributes(date_published: Date.yesterday)
    article2.update_attributes(date_published: 5.days.ago)
    article3.update_attributes(date_published: 2.days.ago)
    article4.update_attributes(date_published: Date.today)
    article5.update_attributes(date_published: Date.today)
    create(:article, home_page_order: 4, status: Article::Status::SUBMITTED_FOR_APPROVAL)
    create(:article, home_page_order: nil)

    get :index

    expected_result = { 1 => article4, 2 => article5, 3 => article1, 4 => article3, 5 => article2, 6 => nil, 7 => nil, 8 => nil }
    expect(assigns[:articles_with_order]).to eq(expected_result)
  end
end
