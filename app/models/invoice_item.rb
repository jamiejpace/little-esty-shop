# frozen_string_literal: true

class InvoiceItem < ApplicationRecord
  self.primary_key = :id

  belongs_to :item
  belongs_to :invoice
  has_one :merchant, through: :item
  has_many :bulk_discounts, through: :merchant

  validates_presence_of :status

  enum status: %w[pending packaged shipped]

  scope :not_shipped, lambda {
    where.not(status: 2)
  }

  scope :revenue, lambda {
    sum('unit_price * quantity')
  }
end
