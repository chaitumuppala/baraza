FactoryGirl.define do
  factory :author do |author|
    full_name { Faker::Name.name }
    email { Faker::Internet.email }
  end
end
