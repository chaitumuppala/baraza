require 'rails_helper'

RSpec.describe ArticleOwner, type: :model do
  describe 'Relationships' do
    it { should belong_to(:article) }
    it { should belong_to(:owner) }
  end

  describe 'Validations' do
    pending "add some examples to (or delete) #{__FILE__}"
  end
end
