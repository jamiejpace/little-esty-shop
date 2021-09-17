class Item < ApplicationRecord
  self.primary_key = :id

  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  scope :merch_items_ship_ready, ->(merchant) {
    joins(:invoices).where('invoice_items.status != ? and items.merchant_id = ?', 2, merchant.id).select(:name, 'invoices.id AS invoices_id', 'invoices.created_at AS invoices_created_at').order("invoices.created_at")
  }
end
