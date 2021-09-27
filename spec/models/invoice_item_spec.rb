# frozen_string_literal: true

require 'rails_helper'
# rspec spec/models/invoice_item_spec.rb
RSpec.describe InvoiceItem, type: :model do
  describe 'validations' do
    it { belong_to :item }
    it { belong_to :invoice }
    it { should validate_presence_of :status }
  end

  describe 'enum' do
    let(:status) { %w[pending packaged shipped] }
    it 'has the right index' do
      status.each_with_index do |item, index|
        expect(InvoiceItem.statuses[item]).to eq(index)
      end
    end
  end

  describe 'scopes and class methods' do
    let(:invoice) { create :invoice }
    let!(:merchant) { create :merchant }
    let!(:customer) { create :customer }
    let!(:customer2) { create :customer }
    let!(:item1) { create :item, { merchant_id: merchant.id } }
    let!(:item2) { create :item, { merchant_id: merchant.id } }
    let!(:item3) { create :item, { merchant_id: merchant.id } }
    let!(:invoice1) { create :invoice, { customer_id: customer.id } }
    let!(:invoice2) { create :invoice, { customer_id: customer2.id } }
    let!(:invoice3) { create :invoice, { customer_id: customer2.id } }
    let!(:transaction1) { create :transaction, { invoice_id: invoice1.id, result: 1 } }
    let!(:transaction2) { create :transaction, { invoice_id: invoice2.id, result: 0 } }
    let!(:inv_item1) do
      create :invoice_item, { item_id: item1.id, invoice_id: invoice1.id, status: 0, quantity: 1, unit_price: 100 }
    end
    let!(:inv_item2) do
      create :invoice_item, { item_id: item2.id, invoice_id: invoice1.id, status: 1, quantity: 2, unit_price: 100 }
    end
    let!(:inv_item3) do
      create :invoice_item, { item_id: item3.id, invoice_id: invoice2.id, status: 2, quantity: 1, unit_price: 150 }
    end

    it 'has not shipped items' do
      expect(InvoiceItem.not_shipped).to eq([inv_item1, inv_item2])
    end

    it 'has a total revenue' do
      expect(InvoiceItem.revenue).to eq(450)
    end
  end

  describe 'instance methods' do
    it '.highest_discount' do
      customer = Customer.create(first_name: "Mose", last_name: "Odell", id: 1)
      merchant_a = Merchant.create(name: "The Gift Shop", id: 1)
      bulk_discount_a = merchant_a.bulk_discounts.create!(name: "Discount A", percentage_discount: 20, quantity_threshold: 10)
      bulk_discount_b = merchant_a.bulk_discounts.create!(name: "Discount B", percentage_discount: 30, quantity_threshold: 15)
      invoice_a = Invoice.create!(customer_id: customer.id, status: 1, id: 1)
      item_a = Item.create!(name: "Hat", description: "Good hat", unit_price: 100, merchant_id: merchant_a.id, status: "enabled", id: 1)
      item_b = Item.create!(name: "Pants", description: "Good pants", unit_price: 100, merchant_id: merchant_a.id, status: "enabled", id: 2)
      invoice_item_1 = InvoiceItem.create!(item_id: item_a.id, invoice_id: invoice_a.id, quantity: 12, unit_price: 100, status: 2, id: 1)
      invoice_item_2 = InvoiceItem.create!(item_id: item_b.id, invoice_id: invoice_a.id, quantity: 15, unit_price: 100, status: 2, id: 2)

      expect(invoice_item_1.highest_discount).to eq(bulk_discount_a)
    end

    it '.revenue_after_discount' do
      customer = Customer.create(first_name: "Mose", last_name: "Odell", id: 1)
      merchant_a = Merchant.create(name: "The Gift Shop", id: 1)
      bulk_discount_a = merchant_a.bulk_discounts.create!(name: "Discount A", percentage_discount: 20, quantity_threshold: 10)
      bulk_discount_b = merchant_a.bulk_discounts.create!(name: "Discount B", percentage_discount: 30, quantity_threshold: 15)
      invoice_a = Invoice.create!(customer_id: customer.id, status: 1, id: 1)
      item_a = Item.create!(name: "Hat", description: "Good hat", unit_price: 100, merchant_id: merchant_a.id, status: "enabled", id: 1)
      item_b = Item.create!(name: "Pants", description: "Good pants", unit_price: 100, merchant_id: merchant_a.id, status: "enabled", id: 2)
      invoice_item_1 = InvoiceItem.create!(item_id: item_a.id, invoice_id: invoice_a.id, quantity: 12, unit_price: 100, status: 2, id: 1)
      invoice_item_2 = InvoiceItem.create!(item_id: item_b.id, invoice_id: invoice_a.id, quantity: 15, unit_price: 100, status: 2, id: 2)

      expect(invoice_item_1.revenue_after_discount).to eq(960)
    end
  end
end
