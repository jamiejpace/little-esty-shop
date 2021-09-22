# frozen_string_literal: true

FactoryBot.define do
  factory :item, class: Item do
    association :merchant
    name { Faker::Commerce.product_name }
    description { Faker::ChuckNorris.fact }
    unit_price { Faker::Number.within(range: 1..100_000) }
    id { Faker::Number.unique.within(range: 1..100_000) }
  end
end
