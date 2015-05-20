FactoryGirl.define do
  factory :admin_user do |user|
    email
    password "Password1!"
  end
end
