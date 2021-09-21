# frozen_string_literal: true

FactoryBot.define do
  factory :customer, class: Customer do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }

    id { Faker::Number.unique.within(range: 1..100_000) }
  end
end
