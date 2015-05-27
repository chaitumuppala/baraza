# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :article do |article|
    title "unite all"
    content "*"*50
  end
end
