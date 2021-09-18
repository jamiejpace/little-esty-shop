class Customer < ApplicationRecord
  self.primary_key = :id

  has_many :invoices, dependent: :destroy

  scope :top_5_customers, -> {
    joins(invoices: :transactions).where('transactions.result = ?', 0)
    .group(:id).order(count: :desc).limit(5)
    .pluck(:first_name, :last_name, Arel.sql("COUNT(transactions.id)"))
  }

  def full_name
    "#{first_name} #{last_name}"
  end
end
