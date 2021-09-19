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

  def self.next_id
    maximum(:id).next || 1
  end

  def self.top_five_merchants
    joins(:transactions).group(:id)
    .select(:name, "SUM(invoice_items.unit_price * invoice_items.quantity) AS total, MAX(invoices.created_at) AS date")
    .where("transactions.result = ?", 0)
    .order(total: :desc).limit(5)
  end

  def items_ready_to_ship
    invoices.merge(InvoiceItem.not_shipped)
    .select("items.name AS name, invoices.id AS invoices_id, invoices.created_at AS invoices_created_at")
    .order(:invoices_created_at)
  end

  def ordered_invoices
    invoices.order(:created_at).distinct
  end

  def fav_customers
    transactions.successful.joins(invoice: :customer).group('customers.id')
    .merge(Customer.full_names)
    .select("COUNT(transactions.id) AS transaction_count")
    .order(transaction_count: :desc).limit(5)
  end

  def top_five_items
    items.joins(:transactions)
    .select("items.*, sum(invoice_items.unit_price * invoice_items.quantity) AS revenue, MAX(invoices.created_at) AS date")
    .where("transactions.result = ?", 0).group(:id).order(revenue: :desc).limit(5)
  end
end
