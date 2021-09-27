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

  describe '.discount_revenue' do
    # before :each do
    #   @merchant = create :merchant
    #   @merchant2 = create :merchant
    #
    #   @bulk_discount1 = @merchant.bulk_discounts.create!(name: "Discount A", percentage_discount: 20, quantity_threshold: 20)
    #   @bulk_discount2 = @merchant.bulk_discounts.create!(name: "Discount B", percentage_discount: 10, quantity_threshold: 10)
    #
    #   @customer = create :customer
    #
    #   @invoice1 = create :invoice, { customer_id: @customer.id, created_at: DateTime.new(2021, 9, 18) }
    #   @invoice2 = create :invoice, { customer_id: @customer.id, created_at: DateTime.new(2021, 9, 17) }
    #
    #   @item1 = create :item, { merchant_id: @merchant.id, status: 'enabled' }
    #   @item2 = create :item, { merchant_id: @merchant.id }
    #   @item3 = create :item, { merchant_id: @merchant2.id }
    #
    #   @invoice_item1 = create :invoice_item,
    #                           { invoice_id: @invoice1.id, item_id: @item1.id, unit_price: 50, quantity: 1, status: 0 }
    #   @invoice_item2 = create :invoice_item,
    #                           { invoice_id: @invoice1.id, item_id: @item2.id, unit_price: 100, quantity: 1, status: 1 }
    #   @invoice_item3 = create :invoice_item,
    #                           { invoice_id: @invoice2.id, item_id: @item3.id, unit_price: 200, quantity: 1, status: 2 }
    # end

    it 'calculates discounted revenue' do
      customer = Customer.create(first_name: "Mose", last_name: "Odell", id: 1)
      merchant_a = Merchant.create(name: "The Gift Shop", id: 1)
      bulk_disoucnt_a = merchant_a.bulk_discounts.create!(name: "Discount A", percentage_discount: 20, quantity_threshold: 10)
      invoice_a = Invoice.create!(customer_id: customer.id, status: 1, id: 1)
      item_a = Item.create!(name: "Hat", description: "Good hat", unit_price: 2000, merchant_id: merchant_a.id, status: "enabled", id: 1)
      item_b = Item.create!(name: "Pants", description: "Good pants", unit_price: 3000, merchant_id: merchant_a.id, status: "enabled", id: 2)
      InvoiceItem.create!(item_id: item_a.id, invoice_id: invoice_a.id, quantity: 5, unit_price: 2000, status: 2, id: 1)
      InvoiceItem.create!(item_id: item_b.id, invoice_id: invoice_a.id, quantity: 5, unit_price: 3000, status: 2, id: 2)

      expect(invoice_a.total_revenue).to eq(25000)
      expect(invoice_a.discount_revenue).to eq(25000)
    end
  end
end
