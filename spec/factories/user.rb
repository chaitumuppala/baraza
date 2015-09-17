# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence :email do |n|
    "email#{n}@factory.com"
  end

  factory :user do |_user|
    email
    password { 'Password1!' }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
<<<<<<< HEAD
    type { RegisteredUser.name }
    confirmed_at { Time.current }
=======
    confirmed_at { Time.now }
>>>>>>> ad844b7f32939b03f31c729c40f9276bbefdf675
  end

  factory :administrator, parent: :user, class: Administrator.name do
    type { Administrator.name }
  end

  factory :editor, parent: :user, class: Editor.name do
    type { Editor.name }
  end

  factory :creator, parent: :user
end
