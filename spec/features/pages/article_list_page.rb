class ArticleListPage
  include Capybara::DSL
  def list
    visit '/articles'
  end
end