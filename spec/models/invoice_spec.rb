require 'rails_helper'
# rspec spec/models/invoice_spec.rb
RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    let(:invoice) { create :invoice }
    let(:status) { ['in progress', 'completed', 'cancelled'] }

    it { should belong_to(:customer) }
    it { should have_many(:invoice_items) }

    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:transactions) }
  end

  describe 'class methods/scopes' do

    let!(:merchant) { create :merchant }
    let!(:customer) { create :customer }
    let!(:customer2) { create :customer }
    let!(:item1) { create :item, { merchant_id: merchant.id } }
    let!(:item2) { create :item, { merchant_id: merchant.id } }
    let!(:item3) { create :item, { merchant_id: merchant.id } }
    let!(:invoice1) { create :invoice, { customer_id: customer.id} }
    let!(:invoice2) { create :invoice, { customer_id: customer2.id} }
    let!(:invoice3) { create :invoice, { customer_id: customer2.id} }
    let!(:transaction1) { create :transaction, { invoice_id: invoice1.id, result: 1} }
    let!(:transaction2) { create :transaction, { invoice_id: invoice2.id, result: 0 } }
    let!(:inv_item1) { create :invoice_item, { item_id: item1.id, invoice_id: invoice1.id } }
    let!(:inv_item2) { create :invoice_item, { item_id: item2.id, invoice_id: invoice1.id } }
    let!(:inv_item3) { create :invoice_item, { item_id: item3.id, invoice_id: invoice2.id } }

    it '#merchant_invoices' do
      expect(Invoice.merchant_invoices(merchant)).to eq([invoice1, invoice1, invoice2])
    end

    it '#for_merchant' do
      expect(Invoice.for_merchant(merchant)).to eq([invoice1, invoice2])
    end

    context 'for merchants' do
      let!(:merchant) { create :merchant }
      let!(:customer) { create :customer }
      let!(:item1) { create :item, { merchant_id: merchant.id } }
      let!(:item2) { create :item, { merchant_id: merchant.id } }
      let!(:item3) { create :item, { merchant_id: merchant.id } }
      let!(:invoice1) { create :invoice, { customer_id: customer.id, status: 0} }
      let!(:invoice2) { create :invoice, { customer_id: customer.id, status: 0} }
      let!(:invoice3) { create :invoice, { customer_id: customer.id, status: 1} }
      let!(:invoice4) { create :invoice, { customer_id: customer.id, status: 2} }
      let!(:inv_item1) { create :invoice_item, { item_id: item1.id, invoice_id: invoice1.id } }
      let!(:inv_item2) { create :invoice_item, { item_id: item2.id, invoice_id: invoice1.id } }
      let!(:inv_item3) { create :invoice_item, { item_id: item3.id, invoice_id: invoice2.id } }

      it '#for_merchant' do
        expect(Invoice.for_merchant(merchant)).to eq([invoice1, invoice2])
      end

      it '#pending_invoices' do
        expect(Invoice.pending_invoices).to eq([invoice1, invoice2])
      end

    end

    it '#merchant_fav_customers' do
      fav = [["#{customer2.first_name} #{customer2.last_name}", 1]]
      expect(Invoice.merchant_fav_customers(merchant)).to eq(fav)
    end
  end
end
