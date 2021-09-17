require 'rails_helper'

RSpec.describe 'Admin Invoice Show Page' do
  before do
    @invoice = create(:invoice)

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
  end
end
