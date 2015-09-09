FactoryGirl.define do
  factory :category do |_category|
    name { Faker::Hacker.adjective }
  end
end
