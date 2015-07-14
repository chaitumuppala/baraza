class HomeController < ApplicationController
  filter_resource_access

  def index
    articles = Article.where(status: Article::Status::PUBLISHED).where.not(home_page_order: nil).order(:home_page_order).group_by(&:home_page_order)
    @articles_with_order = (1..8).inject({}) do |result, order|
      result[order] = articles[order].try(:first)
      result
    end
  end
end