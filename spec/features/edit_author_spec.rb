require 'rails_ui_helper'

describe 'edit author details' do

  before :each do
    @login_page.login
    @author_name = 'Orville Khangale'
    @author_email = "ok@gmail.com"
  end

  it 'Edit author details from home page' do
    @add_author_page.go_to_authors
    @add_author_page.enter_author_details(@author_name, @author_email)
    @add_author_page.go_to_authors
    @add_author_page.click_edit(@author_name,@author_email)
    @add_author_page.enter_author_details("Orvile More", "om@gmail.com")
    expect(page).to have_content("Orvile More 	om@gmail.com")
  end

  it 'Edit author details on edit article' do

  end

  it 'admin cannot change authour on article submited by user' do

  end
end