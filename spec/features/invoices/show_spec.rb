require 'rails_helper'
# rspec spec/features/invoices/show_spec.rb
RSpec.describe 'Merchant Invoice Show Page' do
  describe 'Merchant Invoice Show Page' do
    before :each do
      @merchant = create :merchant
      @merchant2 = create :merchant

      @customer = create :customer

      @invoice1 = create :invoice, { customer_id: @customer.id, created_at: DateTime.new(2021, 9, 18) }
      @invoice2 = create :invoice, { customer_id: @customer.id, created_at: DateTime.new(2021, 9, 17) }

      @item1 = create :item, { merchant_id: @merchant.id, status: "enabled" }
      @item2 = create :item, { merchant_id: @merchant.id }
      @item3 = create :item, { merchant_id: @merchant2.id }

      @invoice_item1 = create :invoice_item, { invoice_id: @invoice1.id, item_id: @item1.id, unit_price: 50, quantity: 1, status: 0 }
      @invoice_item2 = create :invoice_item, { invoice_id: @invoice1.id, item_id: @item2.id, unit_price: 100, quantity: 1, status: 1 }
      @invoice_item3 = create :invoice_item, { invoice_id: @invoice2.id, item_id: @item3.id, unit_price: 200, quantity: 1, status: 2 }

      visit merchant_invoice_path(@merchant, @invoice1)
    end

    it 'has invoice attributes' do
      expect(page).to have_content(@invoice1.id)
      expect(page).to have_content(@invoice1.status)
      expect(page).to have_content('Saturday, September 18, 2021')
      expect(page).to have_content(@invoice1.customer.full_name)
      expect(page).to have_content(@invoice1.total_revenue)
      expect(page).to have_content("$150.00")
    end

    context "Merchant Invoice Show Page - Invoice Item Information" do
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
end
