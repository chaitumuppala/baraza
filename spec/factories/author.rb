FactoryGirl.define do
  factory :author do |_author|
    full_name { Faker::Name.name }
    email { Faker::Internet.email }
  end
end
