require 'rails_helper'

RSpec.describe StaticController, type: :controller do
  it 'should render about' do
    get :about
    expect(response).to render_template('about')
  end

  it 'should render contact' do
    get :contact
    expect(response).to render_template('contact')
  end
end
