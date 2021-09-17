require 'rails_helper'
# rspec spec/models/item_spec.rb
RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items) }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe 'class method/scope' do
    let(:status){['pending','packaged','shipped']}
    let!(:merchant1) { create(:merchant) }
    let!(:merchant2) { create(:merchant) }
    let!(:customer) { create :customer }
    let!(:item1) { create :item, { merchant_id: merchant1.id } }
    let!(:item2) { create :item, { merchant_id: merchant1.id } }
    let!(:item3) { create :item, { merchant_id: merchant1.id } }
    let!(:item4) { create :item, { merchant_id: merchant1.id } }
    let!(:item5) { create :item, { merchant_id: merchant2.id } }
    let!(:invoice1) { create :invoice, { customer_id: customer.id} }
    let!(:inv_item1) { create :invoice_item, { item_id: item1.id, invoice_id: invoice1.id, status: 1 } }
    let!(:inv_item2) { create :invoice_item, { item_id: item2.id, invoice_id: invoice1.id, status: 2 } }
    let!(:inv_item3) { create :invoice_item, { item_id: item2.id, invoice_id: invoice1.id, status: 0 } }
    let!(:inv_item4) { create :invoice_item, { item_id: item3.id, invoice_id: invoice1.id, status: 1 } }
    let!(:inv_item5) { create :invoice_item, { item_id: item4.id, invoice_id: invoice1.id, status: 0  } }
    let!(:inv_item6) { create :invoice_item, { item_id: item5.id, invoice_id: invoice1.id, status: 1  } }

    it 'queries a merchants items not ready to ship' do
      expect(Item.merch_items_ship_ready(merchant1)[0].name).to eq(item1.name)
      expect(Item.merch_items_ship_ready(merchant1)[0].invoices_id).to eq(invoice1.id)
    end
  end
end
