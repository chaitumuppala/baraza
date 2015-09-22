require 'rails_ui_helper'

describe 'Search' do

  it 'should serarch for article' do
    @home_page.home
    @home_page.search("article name")
   # expect(page).to have_content("No results found")
  end
end