class Customer < ApplicationRecord
  self.primary_key = :id

  has_many :invoices, dependent: :destroy
  has_many :transactions, through: :invoices

  scope :top_5_customers, -> {
    # joins(:transactions).where('transactions.result = ?', 0)
    # joins(:transactions).merge(Transaction.successful)
    result = joins(:transactions).merge(Transaction.successful)
    .group(:id).order(count: :desc).limit(5)
    # .pluck(:first_name, :last_name, Arel.sql("COUNT(transactions.id)"))
    .select(:first_name, :last_name, "COUNT(transactions.id) AS transaction_count")

    result.map do |r|
      [r.first_name, r.last_name, r.transaction_count]
    end
  }

  scope :full_names, -> {
    select("customers.first_name || ' ' || customers.last_name AS customer_name")
  }
end
