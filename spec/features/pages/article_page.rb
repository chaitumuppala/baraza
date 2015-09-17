class ArticlePage
  include Capybara::DSL
  def edit(article)
    view(article)
    click_link "Edit"
  end

  def view(article)
    click_link article.title
  end
  def submit_for_approval
    click_button "Submit for approval"
  end
end