FactoryGirl.define do
  factory :article do |article|
    title "unite all"
    content "*"*50
    summary "$"*50
    categories {[build(:category)]}
    status Article::Status::DRAFT
    user
  end
end
