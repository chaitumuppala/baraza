FactoryGirl.define do
  factory :tag do |tag|
    name { Faker::Name.name }
  end
end
