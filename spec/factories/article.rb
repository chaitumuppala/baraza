FactoryGirl.define do
  factory :article do |article|
    title "unite all"
    content "*"*50
    summary "$"*50
    category
    status Article::Status::DRAFT
    user
  end
end
