require 'rails_helper'

RSpec.describe Subscriber, type: :model do
  it { is_expected.to validate_uniqueness_of :email }
end
