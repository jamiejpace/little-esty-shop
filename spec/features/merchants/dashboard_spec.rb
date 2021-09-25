# frozen_string_literal: true

require 'rails_helper'
# rspec spec/features/merchants/dashboard_spec.rb
RSpec.describe 'Merchant Dashboard Show Page' do
  describe 'Merchant Dashboard Show Page' do
    let!(:merchant1) { create(:merchant) }
    let!(:customer) { create :customer }
    let!(:customer2) { create :customer }
    let!(:customer3) { create :customer }
    let!(:customer4) { create :customer }
    let!(:customer5) { create :customer }
    let!(:customer6) { create :customer }
    let!(:item1) { create :item, { merchant_id: merchant1.id } }
    let!(:item2) { create :item, { merchant_id: merchant1.id } }
    let!(:item3) { create :item, { merchant_id: merchant1.id } }
    let!(:invoice1) { create :invoice, { customer_id: customer.id } }
    let!(:invoice2) { create :invoice, { customer_id: customer2.id, created_at: Date.today - 2 } }
    let!(:invoice3) { create :invoice, { customer_id: customer2.id, created_at: Date.today } }
    let!(:invoice4) { create :invoice, { customer_id: customer2.id } }
    let!(:invoice5) { create :invoice, { customer_id: customer2.id } }
    let!(:invoice6) { create :invoice, { customer_id: customer2.id } }
    let!(:invoice7) { create :invoice, { customer_id: customer6.id } }
    let!(:invoice8) { create :invoice, { customer_id: customer6.id } }
    let!(:invoice9) { create :invoice, { customer_id: customer6.id } }
    let!(:invoice10) { create :invoice, { customer_id: customer6.id } }
    let!(:invoice11) { create :invoice, { customer_id: customer3.id } }
    let!(:invoice12) { create :invoice, { customer_id: customer3.id } }
    let!(:invoice13) { create :invoice, { customer_id: customer3.id } }
    let!(:invoice14) { create :invoice, { customer_id: customer4.id } }
    let!(:invoice15) { create :invoice, { customer_id: customer4.id } }
    let!(:invoice16) { create :invoice, { customer_id: customer5.id } }
    let!(:transaction1) { create :transaction, { invoice_id: invoice1.id, result: 1 } }
    let!(:transaction2) { create :transaction, { invoice_id: invoice2.id, result: 0 } }
    let!(:transaction3) { create :transaction, { invoice_id: invoice3.id, result: 0 } }
    let!(:transaction4) { create :transaction, { invoice_id: invoice4.id, result: 0 } }
    let!(:transaction5) { create :transaction, { invoice_id: invoice5.id, result: 0 } }
    let!(:transaction6) { create :transaction, { invoice_id: invoice6.id, result: 0 } }
    let!(:transaction7) { create :transaction, { invoice_id: invoice7.id, result: 0 } }
    let!(:transaction8) { create :transaction, { invoice_id: invoice8.id, result: 0 } }
    let!(:transaction9) { create :transaction, { invoice_id: invoice9.id, result: 0 } }
    let!(:transaction10) { create :transaction, { invoice_id: invoice10.id, result: 0 } }
    let!(:transaction11) { create :transaction, { invoice_id: invoice11.id, result: 0 } }
    let!(:transaction12) { create :transaction, { invoice_id: invoice12.id, result: 0 } }
    let!(:transaction13) { create :transaction, { invoice_id: invoice13.id, result: 0 } }
    let!(:transaction14) { create :transaction, { invoice_id: invoice14.id, result: 0 } }
    let!(:transaction15) { create :transaction, { invoice_id: invoice15.id, result: 0 } }
    let!(:transaction16) { create :transaction, { invoice_id: invoice16.id, result: 0 } }
    let!(:inv_item1) { create :invoice_item, { item_id: item1.id, invoice_id: invoice1.id, status: 2 } }
    let!(:inv_item2) { create :invoice_item, { item_id: item2.id, invoice_id: invoice2.id, status: 0 } }
    let!(:inv_item3) { create :invoice_item, { item_id: item3.id, invoice_id: invoice3.id, status: 0 } }
    let!(:inv_item4) { create :invoice_item, { item_id: item3.id, invoice_id: invoice4.id, status: 0 } }
    let!(:inv_item5) { create :invoice_item, { item_id: item3.id, invoice_id: invoice5.id, status: 2 } }
    let!(:inv_item6) { create :invoice_item, { item_id: item3.id, invoice_id: invoice6.id, status: 2 } }
    let!(:inv_item7) { create :invoice_item, { item_id: item3.id, invoice_id: invoice7.id, status: 2 } }
    let!(:inv_item8) { create :invoice_item, { item_id: item3.id, invoice_id: invoice8.id, status: 2 } }
    let!(:inv_item9) { create :invoice_item, { item_id: item3.id, invoice_id: invoice9.id, status: 2 } }
    let!(:inv_item10) { create :invoice_item, { item_id: item3.id, invoice_id: invoice10.id, status: 2 } }
    let!(:inv_item11) { create :invoice_item, { item_id: item3.id, invoice_id: invoice11.id, status: 2 } }
    let!(:inv_item12) { create :invoice_item, { item_id: item3.id, invoice_id: invoice12.id, status: 2 } }
    let!(:inv_item13) { create :invoice_item, { item_id: item3.id, invoice_id: invoice13.id, status: 2 } }
    let!(:inv_item14) { create :invoice_item, { item_id: item3.id, invoice_id: invoice14.id, status: 1 } }
    let!(:inv_item15) { create :invoice_item, { item_id: item3.id, invoice_id: invoice15.id, status: 1 } }
    let!(:inv_item16) { create :invoice_item, { item_id: item3.id, invoice_id: invoice16.id, status: 1 } }

    before :each do
      visit merchant_dashboard_path(merchant1.id)
    end

    it 'shows merchant dashboard attributes' do
      expect(page).to have_content(merchant1.name)
    end

    describe 'links' do
      it 'has links to the merchants items' do
        click_on 'Items'

        expect(current_path).to eq(merchant_items_path(merchant1))
      end

      it 'has links to the merchants Invoices' do
        click_on 'Invoices'

        expect(current_path).to eq(merchant_invoices_path(merchant1))
      end

      it 'has a link to bulk discounts' do
        click_on 'Bulk Discounts'

        expect(current_path).to eq(merchant_bulk_discounts_path(merchant1))
      end
    end

    describe 'statistics - favorite customers' do
      it 'has text' do
        expect(page).to have_content("Top 5 Customers")
        expect(page).to have_content("Customer Name")
        expect(page).to have_content("Successful Transactions")
      end

      it 'shows names of the top five customers with successful transactions' do
        fav2 = "#{customer2.first_name} #{customer2.last_name}"
        fav6 = "#{customer6.first_name} #{customer6.last_name}"
        fav3 = "#{customer3.first_name} #{customer3.last_name}"
        fav4 = "#{customer4.first_name} #{customer4.last_name}"
        fav5 = "#{customer5.first_name} #{customer5.last_name}"

        expect(fav2).to appear_before(fav6)
        expect(fav6).to appear_before(fav3)
        expect(fav3).to appear_before(fav4)
        expect(fav4).to appear_before(fav5)
        expect(fav5).to_not appear_before(fav2)
      end

      it 'shows the count of transaction next to each customer' do
        fav2 = "#{customer2.first_name} #{customer2.last_name}"
        fav6 = "#{customer6.first_name} #{customer6.last_name}"
        fav3 = "#{customer3.first_name} #{customer3.last_name}"
        fav4 = "#{customer4.first_name} #{customer4.last_name}"
        fav5 = "#{customer5.first_name} #{customer5.last_name}"
        expect(page).to have_content("#{customer2.first_name} #{customer2.last_name}")
        expect(page).to have_content(5)
        expect(page).to have_content("#{customer6.first_name} #{customer6.last_name}")
        expect(page).to have_content(4)
        expect(page).to have_content("#{customer3.first_name} #{customer3.last_name}")
        expect(page).to have_content(3)
        expect(page).to have_content("#{customer4.first_name} #{customer4.last_name}")
        expect(page).to have_content(2)
        expect(page).to have_content("#{customer5.first_name} #{customer5.last_name}")
        expect(page).to have_content(1)
      end
    end

    describe 'Items Ready to Ship' do
      it 'has text' do
        expect(page).to have_content('Items Ready to Ship:')
        expect(page).to have_content('Item Name:')
        expect(page).to have_content('Created at:')
        expect(page).to have_content('Invoice ID:')
      end

      it 'lists names of ordered items not shipped' do
        merchant = create(:merchant)
        bestitem = double('fake_item')

        allow(bestitem).to receive(:name).and_return('Jasmine')
        allow(bestitem).to receive(:invoices_created_at).and_return(Date.new(1994, 12, 27))
        allow(bestitem).to receive(:invoices_id).and_return(21)
        allow_any_instance_of(Merchant).to receive(:items_ready_to_ship).and_return([bestitem])

        visit merchant_dashboard_path(merchant)

        expect(page).to have_content('Item Name: Jasmine')
        expect(page).to have_content('Invoice ID: 21')
      end

      it 'has links to merchant invoice show page next to each item' do
        expect(page).to have_link(invoice4.id)

        click_link invoice4.id

        expect(current_path).to eq("/merchants/#{merchant1.id}/invoices/#{invoice4.id}")
      end

      it 'date invoice was created formatted next to item name' do
        expect(page).to have_content("Created at: #{invoice1.created_at.strftime('%A, %B %-d, %Y')}")
      end

      it 'orders items ready to ship by invoice created date oldest to newest' do
        expect(item2.name).to appear_before(item3.name)
      end
    end
  end
end
