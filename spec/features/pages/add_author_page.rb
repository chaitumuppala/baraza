class AddAuthorPage
  include Capybara::DSL

  def enter_author_details(name, email)
    click_new
    fill_in('author_full_name', :with => name)
    fill_in('author_email', :with => email)
    click_on("Save")
  end

  def click_new
    click_link('New Author')
  end

  def go_to_authors
    find(:xpath, '//*[@id="user-drop"]/li[1]/a').click
  end

  def click_edit(name, email)

    all('tr').each do |tr|
      if tr.all('td')[1] == name && tr.all('td')[2] == email
        tr.all('td')[3].click_link('Edit')
      end
    end
  end
end