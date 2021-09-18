class InvoiceItem < ApplicationRecord
  self.primary_key = :id

  belongs_to :item
  belongs_to :invoice

  validates_presence_of :status

  enum status: %w(pending packaged shipped)
end
