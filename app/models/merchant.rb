class Merchant < ApplicationRecord
  self.primary_key = :id
  validates_presence_of :name

  has_many :items, dependent: :destroy
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices

  scope :by_status, ->(status) {
    where(status: status)
  }

  scope :get_highest_id, -> {
    maximum(:id) || 1
  }

  def self.top_five_merchants
    joins(items: { invoices: :transactions } ).group(:id)
    .select(:name, "SUM(invoice_items.unit_price * invoice_items.quantity) AS total")
    .where("transactions.result = ?", 0)
    .order(total: :desc).limit(5)
  end

  def top_five_items
    items.joins(invoice_items: {invoice: :transactions}).select("items.*, sum(invoice_items.unit_price * invoice_items.quantity) AS revenue").where("transactions.result = ?", 0).group(:id).order(revenue: :desc).limit(5)
  end
end
