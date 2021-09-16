require 'rails_helper'
# rspec spec/models/invoice_item_spec.rb
RSpec.describe InvoiceItem, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  # let(:invoice_item){ create :invoice_item}

  describe 'validations' do
    it { belong_to :item }
    it { belong_to :invoice }
  end

  describe 'enum' do
    let(:status){['pending','packaged','shipped']}
    it 'has the right index' do
      status.each_with_index do |item, index|
        expect(InvoiceItem.statuses[item]).to eq(index)
      end
    end
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
      expected = [
        [item1.name, invoice1.id, inv_item1.status],
        [item2.name, invoice1.id, inv_item3.status],
        [item3.name, invoice1.id, inv_item4.status],
        [item4.name, invoice1.id, inv_item5.status]
      ]

      expect(InvoiceItem.merch_items_ship_ready(merchant1)).to eq(expected.sort)
    end
  end
end
