class HomeController < ApplicationController
  filter_resource_access

  def index
    @articles = Article.all
  end
end