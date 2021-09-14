require 'rails_helper'

RSpec.describe 'admin dashboard' do
  before :each do
    visit admin_dashboard_path
  end

  it 'has an admin header' do
    expect(page).to have_content("Admin Dashboard")
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
end
