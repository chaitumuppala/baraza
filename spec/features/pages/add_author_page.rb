
class AddAuthorPage
  include Capybara::DSL

  def add(name="Orvile Khangale", email="ok@mail.com")
    click_link('New Author')
      fill_in('author_full_name', :with => name)
      fill_in('author_email', :with => email)
    click_on("Save")
    end

  def go_to_authors
     find(:xpath, '//*[@id="user-drop"]/li[1]/a').click
  end
end