require 'rails_helper'

RSpec.describe 'Admin Merchant Index' do
  describe 'index page' do
    before :each do
      @merchant_1 = create(:merchant)
      @merchant_2 = create(:merchant)
      @merchant_3 = create(:merchant)
      visit admin_merchants_path
    end

    it 'has links to all the merchants' do
      expect(page).to have_link(@merchant_1.name)
      expect(page).to have_link(@merchant_2.name)
      expect(page).to have_link(@merchant_3.name)
    end

    it 'links are routed correctly' do
      click_on @merchant_1.name
      expect(current_path).to eq(admin_merchant_path(@merchant_1))
    end
  end
end
