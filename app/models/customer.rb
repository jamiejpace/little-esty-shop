class Customer < ApplicationRecord
  self.primary_key = :id

  has_many :invoices, dependent: :destroy

  scope :top_5_customers, -> {
    joins(invoices: :transactions).where('transactions.result = ?', 0)
      .group(:id).order('COUNT(transactions.id) DESC').limit(5)
  }
end
