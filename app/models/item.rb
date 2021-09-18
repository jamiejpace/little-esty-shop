class Item < ApplicationRecord
  self.primary_key = :id

  validates_presence_of :name
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices

  scope :merch_items_ship_ready, ->(merchant) {
    # joins(:invoices)
    # .where('invoice_items.status != ? and items.merchant_id = ?', 2, merchant.id)
    # .select(:name, 'invoices.id AS invoices_id', 'invoices.created_at AS invoices_created_at')
    # .order("invoices.created_at")
    merchant.items_ready_to_ship
  }

  scope :by_status, ->(status) {
    where(status: status)
  }
end
