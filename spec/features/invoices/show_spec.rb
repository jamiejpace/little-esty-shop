# frozen_string_literal: true

require 'rails_helper'
# rspec spec/features/invoices/show_spec.rb
RSpec.describe 'Merchant Invoice Show Page' do
  describe 'show page' do
    before :each do
      @merchant = create :merchant
      @merchant2 = create :merchant

      @bulk_discount1 = @merchant.bulk_discounts.create!(name: "Discount A", percentage_discount: 20, quantity_threshold: 20)
      @bulk_discount2 = @merchant.bulk_discounts.create!(name: "Discount B", percentage_discount: 10, quantity_threshold: 10)

      @customer = create :customer

      @invoice1 = create :invoice, { customer_id: @customer.id, created_at: DateTime.new(2021, 9, 18) }
      @invoice2 = create :invoice, { customer_id: @customer.id, created_at: DateTime.new(2021, 9, 17) }

      @item1 = create :item, { merchant_id: @merchant.id, status: 'enabled' }
      @item2 = create :item, { merchant_id: @merchant.id }
      @item3 = create :item, { merchant_id: @merchant2.id }

      @invoice_item1 = create :invoice_item,
                              { invoice_id: @invoice1.id, item_id: @item1.id, unit_price: 50, quantity: 1, status: 0 }
      @invoice_item2 = create :invoice_item,
                              { invoice_id: @invoice1.id, item_id: @item2.id, unit_price: 100, quantity: 1, status: 1 }
      @invoice_item3 = create :invoice_item,
                              { invoice_id: @invoice2.id, item_id: @item3.id, unit_price: 200, quantity: 1, status: 2 }

      visit merchant_invoice_path(@merchant, @invoice1)
    end

    it 'has invoice attributes' do
      expect(page).to have_content(@invoice1.id)
      expect(page).to have_content(@invoice1.status)
      expect(page).to have_content('Saturday, September 18, 2021')
      expect(page).to have_content(@invoice1.customer.full_name)
      expect(page).to have_content(@invoice1.total_revenue)
      expect(page).to have_content('$150.00')
    end

    context 'Merchant Invoice Show Page - Invoice Item Information' do
      it "lists all invoice items' names, quantity, price, status" do
        expect(page).to have_content(@invoice_item1.item.name)
        expect(page).to have_content(@invoice_item1.quantity)
        expect(page).to have_content(@invoice_item1.unit_price)
        expect(page).to have_content(@invoice_item1.status)
        expect(page).to have_no_content(@invoice_item3.item.name)
      end

      it 'updates inv item status' do
        within "#inv_item-#{@invoice_item1.id}" do
          expect(find_field('invoice_item_status').value).to eq('pending')
          select 'packaged'
          click_on 'Update'
        end
        expect(current_path).to eq(merchant_invoice_path(@merchant, @invoice1))

        within "#inv_item-#{@invoice_item1.id}" do
          expect(find_field('invoice_item_status').value).to eq('packaged')
          expect(page).to have_content('packaged')
        end
      end
    end
  end

  describe 'discounted revenue' do
    it 'displays the total discounted revenue for the merchant with bulk discounts' do
      customer1 = Customer.create(first_name: "Mose", last_name: "Odell", id: 1)
      merchant_a = Merchant.create(name: "The Gift Shop", id: 1)
      merchant_b = Merchant.create(name: "Toy Store", id: 2)
      bulk_discount_a = merchant_a.bulk_discounts.create!(name: "Discount A", percentage_discount: 20, quantity_threshold: 10)
      bulk_discount_b = merchant_a.bulk_discounts.create!(name: "Discount B", percentage_discount: 30, quantity_threshold: 15)
      invoice_a = Invoice.create!(customer_id: customer1.id, status: 1, id: 1)
      item_a1 = Item.create!(name: "Hat", description: "Good hat", unit_price: 100, merchant_id: merchant_a.id, status: "enabled", id: 1)
      item_a2 = Item.create!(name: "Pants", description: "Good pants", unit_price: 100, merchant_id: merchant_a.id, status: "enabled", id: 2)
      item_b = Item.create!(name: "Lego Tree House", description: "Lego Set", unit_price: 100, merchant_id: merchant_b.id, status: "enabled", id: 3)
      InvoiceItem.create!(item_id: item_a1.id, invoice_id: invoice_a.id, quantity: 12, unit_price: 100, status: 2, id: 1)
      InvoiceItem.create!(item_id: item_a2.id, invoice_id: invoice_a.id, quantity: 15, unit_price: 100, status: 2, id: 2)
      InvoiceItem.create!(item_id: item_b.id, invoice_id: invoice_a.id, quantity: 15, unit_price: 100, status: 2, id: 3)

      visit merchant_invoice_path(merchant_a, invoice_a)

      expect(page).to have_content("Discounted Revenue: $3,510.00")
    end
  end
end
