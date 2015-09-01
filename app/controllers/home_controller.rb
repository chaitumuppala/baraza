class HomeController < ApplicationController
  filter_resource_access

  def index
    @published_articles = Article.includes(:tags, :category, :users, :system_users, :cover_image).where(status: Article::Status::PUBLISHED).order("date_published desc")
    articles_with_order = @published_articles.order(:home_page_order).select{ |article| article.home_page_order.present? }.group_by(&:home_page_order)
    articles_without_home_page_order = @published_articles.select{|article| article.home_page_order.blank?}
    articles_without_home_page_order_index = 0
    # TODO: Vijay: What does this magic number 8 represent?
    @articles_with_order = (1..8).inject({}) do |result, order|
      result[order] = articles_with_order[order].try(:first)
      if result[order].blank?
        result[order] = articles_without_home_page_order[articles_without_home_page_order_index]
        articles_without_home_page_order_index+=1
      end
      result
    end
  end
end
