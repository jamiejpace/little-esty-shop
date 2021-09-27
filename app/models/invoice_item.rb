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

  def revenue
    unit_price * quantity
  end

  def highest_discount
    bulk_discounts.where('bulk_discounts.quantity_threshold <= ?', quantity)
                  .select('bulk_discounts.*')
                  .order(percentage_discount: :desc)
                  .first
  end

  def revenue_after_discount
    revenue * (1 - (highest_discount.percentage_discount.to_f / 100) )
  end
end
