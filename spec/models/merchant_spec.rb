require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships/validations' do

    it { should have_many :items }
    it { should validate_presence_of :name }

    it 'validates default disabled status' do
      merchant = create(:merchant)
      expect(merchant.status).to eq("disabled")
    end
  end

  describe 'class methods/scopes' do
    describe 'by status' do
      before :each do
        @merch1 = create :merchant, { status: 'enabled'}
        @merch2 = create :merchant
        @merch3 = create :merchant, { status: 'enabled'}
        @merch4 = create :merchant
      end

      it 'has disabled' do
        expect(Merchant.by_status('disabled')).to eq([@merch2, @merch4])
      end

      it 'has enabled' do
        expect(Merchant.by_status('enabled')).to eq([@merch1, @merch3])
      end
    end
  end 

  describe 'top 5 merchants by revenue' do
    let!(:merch1) { create :merchant }
    let!(:merch2) { create :merchant }
    let!(:merch3) { create :merchant }
    let!(:merch4) { create :merchant }
    let!(:merch5) { create :merchant }
    let!(:merch6) { create :merchant }

    let!(:item1) { create :item, { merchant_id: merch1.id } }

    let!(:item2) { create :item, { merchant_id: merch2.id } }
    let!(:item3) { create :item, { merchant_id: merch2.id } }

    let!(:item4) { create :item, { merchant_id: merch3.id } }
    let!(:item5) { create :item, { merchant_id: merch3.id } }

    let!(:item6) { create :item, { merchant_id: merch4.id } }
    let!(:item7) { create :item, { merchant_id: merch4.id } }

    let!(:item8) { create :item, { merchant_id: merch5.id } }
    let!(:item9) { create :item, { merchant_id: merch5.id } }

    let!(:item10) { create :item, { merchant_id: merch6.id } }

    let!(:customer) { create :customer }

    let!(:invoice1) { create :invoice, { customer_id: customer.id, created_at: Date.today - 1} }
    let!(:invoice2) { create :invoice, { customer_id: customer.id, created_at: Date.today } }
    let!(:invoice3) { create :invoice, { customer_id: customer.id, created_at: Date.today } }

    let!(:transaction1) { create :transaction, { invoice_id: invoice1.id, result: 0 } }
    let!(:transaction2) { create :transaction, { invoice_id: invoice2.id, result: 0 } }
    let!(:transaction3) { create :transaction, { invoice_id: invoice2.id, result: 0 } }
    let!(:transaction4) { create :transaction, { invoice_id: invoice3.id, result: 1 } }

    let!(:inv_item1) { create :invoice_item, { invoice_id: invoice1.id, item_id: item1.id, unit_price: 50, quantity: 1 } } # 1, 50

    let!(:inv_item2) { create :invoice_item, { invoice_id: invoice2.id, item_id: item2.id, unit_price: 100, quantity: 1 } } # 2, 300
    let!(:inv_item3) { create :invoice_item, { invoice_id: invoice2.id, item_id: item3.id, unit_price: 200, quantity: 1 } }

    let!(:inv_item4) { create :invoice_item, { invoice_id: invoice2.id, item_id: item4.id, unit_price: 100, quantity: 1 } } # 3, 100
    let!(:inv_item5) { create :invoice_item, { invoice_id: invoice3.id, item_id: item5.id, unit_price: 100, quantity: 1 } }

    let!(:inv_item6) { create :invoice_item, { invoice_id: invoice2.id, item_id: item6.id, unit_price: 300, quantity: 1 } } # 4, 600
    let!(:inv_item7) { create :invoice_item, { invoice_id: invoice2.id, item_id: item7.id, unit_price: 300, quantity: 1 } }

    let!(:inv_item8) { create :invoice_item, { invoice_id: invoice2.id, item_id: item8.id, unit_price: 200, quantity: 1 } } # 5, 500
    let!(:inv_item9) { create :invoice_item, { invoice_id: invoice1.id, item_id: item9.id, unit_price: 300, quantity: 1 } }

    let!(:inv_item10) { create :invoice_item, { invoice_id: invoice1.id, item_id: item10.id, unit_price: 150, quantity: 1 } } # 6, 150


    it 'has the top 5 merchants name, total, day' do
      # 4, 5, 2, 6, 3
      expected = [
        [merch4.name, 600, Date.today], # 1200
        [merch5.name, 500, Date.today - 1], # 700
        [merch2.name, 300, Date.today], # 600
        [merch6.name, 150, Date.today - 1], # 300
        [merch3.name, 100, Date.today] # 150
      ]
      binding.pry

      expect(Merchant.top_five_merchants).to eq(expected)
    end
  end
end
