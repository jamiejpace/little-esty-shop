FactoryBot.define do
  factory :bulk_discount do
    percentage_discount { Faker::Number.within(range: 1..30) }
    quantity_threshold { Faker::Number.within(range: 10..50) }
  end
end
