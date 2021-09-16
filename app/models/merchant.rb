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
end
