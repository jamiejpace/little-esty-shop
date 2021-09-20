class InvoiceItem < ApplicationRecord
  self.primary_key = :id

  belongs_to :item
  belongs_to :invoice

  validates_presence_of :status

  enum status: %w(pending packaged shipped)

  scope :not_shipped, -> {
    where.not(status: 2)
  }

  scope :revenue, -> {
    sum("unit_price * quantity")
  }
end
