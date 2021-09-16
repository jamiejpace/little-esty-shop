class Merchant < ApplicationRecord
  self.primary_key = :id
  validates_presence_of :name

  has_many :items, dependent: :destroy

  scope :by_status, ->(status) {
    where(status: status)
  }

  scope :get_highest_id, -> {
    maximum(:id) || 1
  }

  scope :top_five_merchants, -> {
    select("SUM(invoice_items.quantity * invoice_items.unit_price) AS total").distinct.joins(items: { invoices: :transactions } )
    .where("transactions.result = ?", 0).group(:id).order(total: :desc).limit(5).pluck(:name, "SUM(invoice_items.quantity * invoice_items.unit_price)")
  }
end
