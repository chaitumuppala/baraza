class HomeController < ApplicationController
  filter_resource_access

  def index
    @published_articles = Article.where(status: Article::Status::PUBLISHED).order(:home_page_order)
    articles = @published_articles.select{ |article| article.home_page_order.present? }.group_by(&:home_page_order)
    @articles_with_order = (1..8).inject({}) do |result, order|
      result[order] = articles[order].try(:first)
      result
    end
  end
end