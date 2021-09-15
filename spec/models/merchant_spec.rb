require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships/validations' do

    it { should have_many :items }
    it { should validate_presence_of :name }

    it 'validates default enabled status' do
      merchant = create(:merchant)
      expect(merchant.status).to eq("enabled")
    end
  end
end
