# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin dashboard' do
  before :each do
    visit admin_dashboard_path
  end

  it 'has an admin header' do
    expect(page).to have_content('Admin Dashboard')
  end

  describe 'links' do
    it 'has link to the admin merchants' do
      click_on 'Admin Merchants'

      expect(current_path).to eq(admin_merchants_path)
    end

    it 'has link to the admin invoices' do
      click_on 'Admin Invoices'

      expect(current_path).to eq(admin_invoices_path)
    end
  end

  describe 'statistices' do
    let(:cust1) { create :customer }
    let(:cust2) { create :customer }
    let(:cust3) { create :customer }
    let(:cust4) { create :customer }
    let(:cust5) { create :customer }
    let(:cust6) { create :customer }
    let(:inv1) { create :invoice, { customer_id: cust1.id, status: 0 } }
    let(:inv2) { create :invoice, { customer_id: cust2.id, status: 1 } }
    let(:inv3) { create :invoice, { customer_id: cust3.id, status: 0 } }
    let(:inv4) { create :invoice, { customer_id: cust4.id, status: 1 } }
    let(:inv5) { create :invoice, { customer_id: cust5.id, status: 0 } }
    let(:inv6) { create :invoice, { customer_id: cust6.id, status: 1 } }
    let!(:trans1) { create :transaction, { invoice_id: inv1.id, result: 0 } }
    let!(:trans2) { create :transaction, { invoice_id: inv1.id, result: 0 } }
    let!(:trans3) { create :transaction, { invoice_id: inv1.id, result: 0 } }
    let!(:trans4) { create :transaction, { invoice_id: inv1.id, result: 0 } }
    let!(:trans16) { create :transaction, { invoice_id: inv1.id, result: 0 } }
    let!(:trans5) { create :transaction, { invoice_id: inv2.id, result: 0 } }
    let!(:trans6) { create :transaction, { invoice_id: inv2.id, result: 0 } }
    let!(:trans7) { create :transaction, { invoice_id: inv3.id, result: 0 } }
    let!(:trans13) { create :transaction, { invoice_id: inv3.id, result: 0 } }
    let!(:trans15) { create :transaction, { invoice_id: inv3.id, result: 0 } }
    let!(:trans8) { create :transaction, { invoice_id: inv4.id, result: 0 } }
    let!(:trans9) { create :transaction, { invoice_id: inv4.id, result: 0 } }
    let!(:trans10) { create :transaction, { invoice_id: inv4.id, result: 0 } }
    let!(:trans14) { create :transaction, { invoice_id: inv4.id, result: 0 } }
    let!(:trans11) { create :transaction, { invoice_id: inv5.id, result: 0 } }
    let!(:trans12) { create :transaction, { invoice_id: inv6.id, result: 1 } }

    before :each do
      visit admin_dashboard_path
    end

    it 'has the top 5 customers and their order count' do
      expect(page).to have_content("#{cust1.first_name} #{cust1.last_name}: 5")
      expect(page).to have_content("#{cust2.first_name} #{cust2.last_name}: 2")
      expect(page).to have_content("#{cust3.first_name} #{cust3.last_name}: 3")
      expect(page).to have_content("#{cust4.first_name} #{cust4.last_name}: 4")
      expect(page).to have_content("#{cust5.first_name} #{cust5.last_name}: 1")
    end

    it 'has pending_invoices' do
      within '#pending-invoices' do
        [inv1, inv3, inv5].each do |inv|
          expected = inv.created_at.strftime('%A, %B %e, %Y')
          expect(page).to have_link(inv.id.to_s)
          expect(page).to have_content(expected)
        end

        [inv2, inv4, inv6].each do |inv|
          expect(page).not_to have_content("Invoice #{inv.id},")
        end
      end
    end

    it 'links are correctly routed' do
      within '#pending-invoices' do
        click_on inv5.id.to_s
      end

      expect(current_path).to eq(admin_invoice_path(inv5))
    end
  end
end
