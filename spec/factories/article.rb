FactoryGirl.define do
  factory :article do
    title { Faker::Name.title }
    content { Faker::Lorem.paragraph }
    summary { Faker::Lorem.sentence }
    association :category
  end
end
