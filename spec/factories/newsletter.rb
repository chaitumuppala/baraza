FactoryGirl.define do
  factory :newsletter do |newsletter|
    name "Month of June"
    status Newsletter::Status::DRAFT
  end
end
