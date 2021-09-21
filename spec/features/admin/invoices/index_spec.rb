# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin Invoices Index' do
  describe 'index page' do
    before do
      @invoice_1 = create(:invoice)
      @invoice_2 = create(:invoice)
      @invoice_3 = create(:invoice)
      @invoice_4 = create(:invoice)
      @invoice_5 = create(:invoice)
      @invoice_6 = create(:invoice)

      visit admin_invoices_path
    end

    it 'when i visit the admin invoices index' do
      expect(current_path).to eq(admin_invoices_path)
    end

    it 'i see a list of all invoice ids in system' do
      expect(page).to have_content(@invoice_1.id.to_s)
      expect(page).to have_content(@invoice_2.id.to_s)
      expect(page).to have_content(@invoice_3.id.to_s)
      expect(page).to have_content(@invoice_4.id.to_s)
      expect(page).to have_content(@invoice_5.id.to_s)
      expect(page).to have_content(@invoice_6.id.to_s)
    end

    it 'each id links to its admin invoice show page' do
      expect(page).to have_link(@invoice_1.id.to_s)
      expect(page).to have_link(@invoice_2.id.to_s)
      expect(page).to have_link(@invoice_3.id.to_s)
      expect(page).to have_link(@invoice_4.id.to_s)
      expect(page).to have_link(@invoice_5.id.to_s)
      expect(page).to have_link(@invoice_6.id.to_s)
    end
  end
end
