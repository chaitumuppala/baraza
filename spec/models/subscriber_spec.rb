# == Schema Information
#
# Table name: subscribers
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# # == Schema Information
# #
# # Table name: subscribers
# #
# #  id         :integer          not null, primary key
# #  email      :string(255)
# #  created_at :datetime         not null
# #  updated_at :datetime         not null
# #
#
# require 'rails_helper'
#
# RSpec.describe Subscriber, type: :model do
#   it { should validate_uniqueness_of(:email).with_message('already subscribed') }
# end
