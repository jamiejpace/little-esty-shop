class Customer < ApplicationRecord
  self.primary_key = :id

  has_many :invoices, dependent: :destroy
  has_many :transactions, through: :invoices

  scope :top_5_customers, -> {
    full_names.joins(:transactions).merge(Transaction.successful)
    .group(:id).order(count: :desc).limit(5)
    .select(:first_name, :last_name, "COUNT(transactions.id) AS transaction_count")
  }

  scope :full_names, -> {
    select("customers.first_name || ' ' || customers.last_name AS customer_name")
  }

  def full_name
    "#{first_name} #{last_name}"
  end
end
