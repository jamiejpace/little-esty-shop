# frozen_string_literal: true

require 'rails_helper'
# rspec spec/models/invoice_spec.rb
RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it { should belong_to(:customer) }
    it { should have_many(:invoice_items) }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:transactions) }
  end

  describe 'class methods/scopes' do
    let(:invoice) { create :invoice }
    let(:status) { ['in progress', 'completed', 'cancelled'] }
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
    let!(:inv_item1) { create :invoice_item, { item_id: item1.id, invoice_id: invoice1.id } }
    let!(:inv_item2) { create :invoice_item, { item_id: item2.id, invoice_id: invoice1.id } }
    let!(:inv_item3) { create :invoice_item, { item_id: item3.id, invoice_id: invoice2.id } }

    context 'for merchants' do
      let!(:merchant) { create :merchant }
      let!(:customer) { create :customer }
      let!(:item1) { create :item, { merchant_id: merchant.id } }
      let!(:item2) { create :item, { merchant_id: merchant.id } }
      let!(:item3) { create :item, { merchant_id: merchant.id } }
      let!(:invoice1) { create :invoice, { customer_id: customer.id, status: 0 } }
      let!(:invoice2) { create :invoice, { customer_id: customer.id, status: 0 } }
      let!(:invoice3) { create :invoice, { customer_id: customer.id, status: 1 } }
      let!(:invoice4) { create :invoice, { customer_id: customer.id, status: 2 } }
      let!(:inv_item1) { create :invoice_item, { item_id: item1.id, invoice_id: invoice1.id, status: 0 } }
      let!(:inv_item2) { create :invoice_item, { item_id: item2.id, invoice_id: invoice1.id, status: 1 } }
      let!(:inv_item3) { create :invoice_item, { item_id: item3.id, invoice_id: invoice2.id, status: 2 } }

      it '#incomplete_invoices' do
        expect(Invoice.incomplete_invoices).to eq([invoice1])
      end

      it 'has a transaction count' do
        result = Invoice.joins(:transactions).transactions_count.group(:id)
        result = result.sum(&:transaction_count)

        expect(result).to eq(2)
      end

      it 'has total revenues' do
        expected = [inv_item1, inv_item2, inv_item3].sum do |inv|
          inv.unit_price * inv.quantity
        end
        result = Invoice.joins(:invoice_items).total_revenues.group(:id)
        result = result.sum(&:revenue)

        expect(result).to eq(expected)
      end
    end
  end

  describe 'instance methods' do
    describe 'total revenue' do
      let!(:customer) { create :customer }
      let!(:merchant) { create :merchant }
      let!(:invoice) { create :invoice, { customer_id: customer.id } }
      let!(:item1) { create :item, { merchant_id: merchant.id } }
      let!(:item2) { create :item, { merchant_id: merchant.id } }
      let!(:item3) { create :item, { merchant_id: merchant.id } }
      let!(:inv_item1) do
        create :invoice_item, { invoice_id: invoice.id, item_id: item1.id, unit_price: 100, quantity: 1 }
      end
      let!(:inv_item2) do
        create :invoice_item, { invoice_id: invoice.id, item_id: item2.id, unit_price: 150, quantity: 2 }
      end
      let!(:inv_item3) do
        create :invoice_item, { invoice_id: invoice.id, item_id: item3.id, unit_price: 300, quantity: 1 }
      end

      it '#total_revenues' do
        expect(invoice.total_revenue).to eq(700)
      end
    end
  end

  it 'calculates total revenue' do
    customer = Customer.create(first_name: "Mose", last_name: "Odell", id: 1)
    merchant_a = Merchant.create(name: "The Gift Shop", id: 1)
    merchant_b = Merchant.create(name: "Toy Store", id: 2)
    bulk_discount_a = merchant_a.bulk_discounts.create!(name: "Discount A", percentage_discount: 20, quantity_threshold: 10)
    bulk_discount_b = merchant_a.bulk_discounts.create!(name: "Discount B", percentage_discount: 30, quantity_threshold: 15)
    invoice_a = Invoice.create!(customer_id: customer.id, status: 1, id: 1)
    item_a1 = Item.create!(name: "Hat", description: "Good hat", unit_price: 100, merchant_id: merchant_a.id, status: "enabled", id: 1)
    item_a2 = Item.create!(name: "Pants", description: "Good pants", unit_price: 100, merchant_id: merchant_a.id, status: "enabled", id: 2)
    item_b = Item.create!(name: "Lego Tree House", description: "Lego Set", unit_price: 100, merchant_id: merchant_b.id, status: "enabled", id: 3)
    InvoiceItem.create!(item_id: item_a1.id, invoice_id: invoice_a.id, quantity: 12, unit_price: 100, status: 2, id: 1)
    InvoiceItem.create!(item_id: item_a2.id, invoice_id: invoice_a.id, quantity: 15, unit_price: 100, status: 2, id: 2)
    InvoiceItem.create!(item_id: item_b.id, invoice_id: invoice_a.id, quantity: 15, unit_price: 100, status: 2, id: 3)

    expect(invoice_a.total_revenue).to eq(4200)
  end

  it '.invoice_items_by_merchant' do
    customer = Customer.create(first_name: "Mose", last_name: "Odell", id: 1)
    merchant_a = Merchant.create(name: "The Gift Shop", id: 1)
    merchant_b = Merchant.create(name: "Toy Store", id: 2)
    bulk_discount_a = merchant_a.bulk_discounts.create!(name: "Discount A", percentage_discount: 20, quantity_threshold: 10)
    bulk_discount_b = merchant_a.bulk_discounts.create!(name: "Discount B", percentage_discount: 30, quantity_threshold: 15)
    invoice_a = Invoice.create!(customer_id: customer.id, status: 1, id: 1)
    item_a1 = Item.create!(name: "Hat", description: "Good hat", unit_price: 100, merchant_id: merchant_a.id, status: "enabled", id: 1)
    item_a2 = Item.create!(name: "Pants", description: "Good pants", unit_price: 100, merchant_id: merchant_a.id, status: "enabled", id: 2)
    item_b = Item.create!(name: "Lego Tree House", description: "Lego Set", unit_price: 100, merchant_id: merchant_b.id, status: "enabled", id: 3)
    InvoiceItem.create!(item_id: item_a1.id, invoice_id: invoice_a.id, quantity: 12, unit_price: 100, status: 2, id: 1)
    InvoiceItem.create!(item_id: item_a2.id, invoice_id: invoice_a.id, quantity: 15, unit_price: 100, status: 2, id: 2)
    InvoiceItem.create!(item_id: item_b.id, invoice_id: invoice_a.id, quantity: 15, unit_price: 100, status: 2, id: 3)

    expect(invoice_a.invoice_items_by_merchant(merchant_a).length).to eq(2)
  end
end
