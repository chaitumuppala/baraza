require 'rails_helper'
describe TagsController do
  render_views

  it 'should render json data on index', sign_in: true do
    tag1 = create(:tag, name: "tag-1")
    tag2 = create(:tag, name: "tag-2")
    tag3 = create(:tag, name: "tag-3")
    get :index, format: 'json'
    expected_body = [tag1.name, tag2.name, tag3.name]
    expect(JSON.parse(response.body)).to eq(expected_body)
  end
end
