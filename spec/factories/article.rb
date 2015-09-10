FactoryGirl.define do
  factory :article do
    association :creator, factory: :user
    title { Faker::Name.title }
    content { Faker::Lorem.paragraph }
    summary { Faker::Lorem.sentence }
    association :category
    tag_list { "" }
  end
end
