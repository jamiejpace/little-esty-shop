class Transaction < ApplicationRecord
  self.primary_key = :id

  belongs_to :invoice

  enum result: %w(success failed)

  scope :successful, -> {
    where(result: 0)
  }
end
