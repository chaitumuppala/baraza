require 'rails_helper'

RSpec.describe TagsController, type: :controller do
  render_views

  context 'index' do
    it 'should render json data on index', sign_in: true do
      tag1 = create(:tag, name: 'tag-1')
      tag2 = create(:tag, name: 'tag-2')
      tag3 = create(:tag, name: '3rd-tag')
      tag4 = create(:tag, name: 'dummy')

      get :index, format: 'json', q: 'tag'

      tag_string = "#{tag1.name},#{tag2.name},#{tag3.name}"
      expected_body = { tags: tag_string }
      expect(assigns[:tags]).to eq(tag_string)
      expect(JSON.parse(response.body)).to eq(expected_body.with_indifferent_access)
    end
  end
end
