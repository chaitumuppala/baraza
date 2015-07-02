FactoryGirl.define do
  factory :article do |article|
    title "unite all"
    content "*"*50
    categories {[build(:category)]}
  end
end
