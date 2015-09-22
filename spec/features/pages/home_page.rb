class HomePage
  include Capybara::DSL

  def home
    visit '/'
  end

  def click_username
    find(:xpath, '//*[@id="username"]/a').click
  end

  def search(keyword)
    search_box = page.document.find_css('a.icon-search')
    search_box.first.click
     #find(:css, 'a.icon-search').click
     #fill_in("q",with: keyword + "\n")
    find(:xpath, '//input[@id="q"]').set(keyword + "\n")
  end

  def to_authors
    visit '/authors'
  end

end