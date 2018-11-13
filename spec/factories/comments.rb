FactoryBot.define do
  factory :comment do
    user
    movie
    content "MyText"
  end
end
