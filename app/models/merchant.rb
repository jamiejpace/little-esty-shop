class Merchant < ApplicationRecord
  self.primary_key = :id
  validates_presence_of :name

  has_many :items, dependent: :destroy

  has_many :merchant_invoices
  has_many :invoices, through: :merchant_invoices

  scope :by_status, ->(status) {
    where(status: status)
  }
end
