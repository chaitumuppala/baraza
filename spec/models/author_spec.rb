# # == Schema Information
# #
# # Table name: authors
# #
# #  id         :integer          not null, primary key
# #  full_name  :string(255)      not null
# #  email      :string(255)
# #  created_at :datetime         not null
# #  updated_at :datetime         not null
# #
#
# require 'rails_helper'
#
# RSpec.describe Author, type: :model do
#   context 'validation' do
#     it { should validate_presence_of(:full_name) }
#     it { should_not allow_value(' ', '', nil).for(:full_name) }
#     it { should validate_presence_of(:email) }
#     it { should_not allow_value(' ', '', nil).for(:email) }
#     it { should allow_value('a@b.com').for(:email) }
#   end
# end
