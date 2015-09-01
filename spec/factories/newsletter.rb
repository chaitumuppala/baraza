FactoryGirl.define do
  factory :newsletter do |newsletter|
    name { Faker::Team.name }
  end
end
