class BulkDiscount < ApplicationRecord
  validates_presence_of :percentage_discount
  validates_presence_of :quantity_threshold

  belongs_to :merchant
  has_many :items, through: :merchant
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
end
