# frozen_string_literal: true

class Invoice < ApplicationRecord
  self.primary_key = :id

  belongs_to :customer
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :transactions, dependent: :destroy

  enum status: ['in progress', 'completed', 'cancelled']

  scope :pending_invoices, lambda {
    where(status: 0).order(:created_at)
  }

  scope :transactions_count, lambda {
    select('COUNT(transactions.id) AS transaction_count')
  }

  scope :total_revenues, lambda {
    select('SUM(invoice_items.unit_price * invoice_items.quantity) AS revenue')
  }

  def total_revenue
    invoice_items.revenue
  end
end
