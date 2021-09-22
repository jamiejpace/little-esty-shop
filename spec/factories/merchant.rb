# frozen_string_literal: true

FactoryBot.define do
  factory :merchant, class: Merchant do
    name { Faker::Company.name }
    id { Faker::Number.unique.within(range: 1..100_000) }
  end
end
