class InvoiceItem < ApplicationRecord
  self.primary_key = :id

  belongs_to :item
  belongs_to :invoice

  enum status: %w(pending packaged shipped)

  scope :merch_items_ship_ready, ->(merchant) {
    joins(:item).select('items.name, invoice_id, status').where('items.merchant_id = ? and invoice_items.status != ?', merchant.id, 2).distinct.pluck("items.name", "invoice_id", "status")
  }
end
