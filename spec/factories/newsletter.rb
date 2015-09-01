FactoryGirl.define do
  factory :newsletter do |_newsletter|
    name { Faker::Team.name }
  end
end
