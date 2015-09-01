FactoryGirl.define do
  factory :tag do |_tag|
    name { Faker::Name.name }
  end
end
