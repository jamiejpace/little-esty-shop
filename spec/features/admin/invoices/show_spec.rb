require 'rails_helper'

RSpec.describe 'Admin Invoice Show Page' do
  before do
    @customer = create(:customer)

    @item_1 = create(:item)
    @item_2 = create(:item)
    @item_3 = create(:item)

    @invoice = create(:invoice, customer_id: @customer.id)

    @invoice_item_1 = create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice.id)
    @invoice_item_2 = create(:invoice_item, item_id: @item_2.id, invoice_id: @invoice.id)
    @invoice_item_3 = create(:invoice_item, item_id: @item_3.id, invoice_id: @invoice.id)

    visit admin_invoice_path(@invoice.id)
  end

  describe 'i see information related to invoice' do
    it 'when i visit an admin invoice show page' do
      expect(current_path).to eq(admin_invoice_path(@invoice.id))
    end

    it 'has invoice id, status, created, cust first and last' do
      expect(page).to have_content(@invoice.id.to_s)
      expect(page).to have_content(@invoice.status.to_s)
      expect(page).to have_content(@invoice.created_at.strftime("%A, %B %e, %Y"))
      expect(page).to have_content(@invoice.customer.first_name)
      expect(page).to have_content(@invoice.customer.last_name)
    end

    it 'has item name, quant, price sold, and inv. item status' do
      expect(page).to have_content(@item_1.name)
      expect(page).to have_content(@item_2.name)
      expect(page).to have_content(@item_3.name)
      expect(page).to have_content(@invoice_item_1.quantity)
      expect(page).to have_content(@invoice_item_2.quantity)
      expect(page).to have_content(@invoice_item_3.quantity)
      expect(page).to have_content(@invoice_item_1.unit_price)
      expect(page).to have_content(@invoice_item_2.unit_price)
      expect(page).to have_content(@invoice_item_3.unit_price)
      expect(page).to have_content(@invoice_item_1.status)
      expect(page).to have_content(@invoice_item_2.status)
      expect(page).to have_content(@invoice_item_3.status)
    end
  end

  describe 'total revenue' do
    let!(:customer) { create :customer }
    let!(:merchant) { create :merchant }
    let!(:invoice) { create :invoice, { customer_id: customer.id } }
    let!(:item) { create :item, { merchant_id: merchant.id } }
    let!(:invoice_item) { create :invoice_item, { invoice_id: invoice.id, item_id: item.id, unit_price: 13000 } }

    it 'shows the total revenue' do
      visit admin_invoice_path(invoice)

      within '#invoice-attr' do
        expect(page).to have_content('$130.00')
      end
    end
  end
end
