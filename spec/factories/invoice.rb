# frozen_string_literal: true

FactoryBot.define do
  factory :invoice, class: Invoice do
    association :customer
    status { ['cancelled', 'completed', 'in progress'].sample }
    id { Faker::Number.unique.within(range: 1..1_000_000) }
  end
end
