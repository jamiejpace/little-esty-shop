FactoryBot.define do
  factory :bulk_discount do
    percentage_discount { 1 }
    quantity_threshold { 1 }
  end
end
