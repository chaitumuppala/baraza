# == Schema Information
#
# Table name: authors
#
#  id         :integer          not null, primary key
#  full_name  :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Author, type: :model do
  context 'validation' do
    it 'should validate presence of email' do
      expect(build(:author, email: nil)).not_to be_valid
    end

    it 'should validate presence of full_name' do
      expect(build(:author, full_name: nil)).not_to be_valid
    end

    it 'should validate uniqueness of email' do
      create(:author, email: 'a@b.com')
      expect(build(:author, email: 'a@b.com')).not_to be_valid
    end
  end
end
