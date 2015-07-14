require 'rails_helper'

describe HomeController do
  it "should fetch published articles with home_page_order" do
    article1 = create(:article, home_page_order: 5, status: Article::Status::PUBLISHED)
    article2 = create(:article, home_page_order: 1, status: Article::Status::PUBLISHED)
    article3 = create(:article, home_page_order: 2, status: Article::Status::PUBLISHED)
    article4 = create(:article, home_page_order: nil, status: Article::Status::PUBLISHED)
    create(:article, home_page_order: 4, status: Article::Status::SUBMITTED_FOR_APPROVAL)
    create(:article, home_page_order: nil)

    get :index

    expected_result = { 1 => article2, 2 => article3, 3 => nil, 4 => nil, 5 => article1, 6 => nil, 7 => nil, 8 => nil }
    expect(assigns[:published_articles]).to eq([article4, article2, article3, article1])
    expect(assigns[:articles_with_order]).to eq(expected_result)
  end
end