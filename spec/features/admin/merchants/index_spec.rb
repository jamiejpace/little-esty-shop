require 'rails_helper'

RSpec.describe 'Admin Merchant Index' do
  describe 'index page' do
    before :each do
      @merchant_1 = create(:merchant)
      @merchant_2 = create(:merchant)
      @merchant_3 = create(:merchant)
      @merchant_4 = create(:merchant, { status: 'disabled' })
      @merchant_5 = create(:merchant, { status: 'disabled' })
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

    it 'has button to enable/disable merchants' do
      expect(page).to have_button('Disable', count: 3)
    end

    it 'changes button dynamically when enable/disabled clicked' do
      within "#merch-#{@merchant_1.id}" do
        expect(page).not_to have_button "Enable #{@merchant_1.name}"
        click_button "Disable #{@merchant_1.name}"
      end

      expect(current_path).to eq(admin_merchants_path)
      @merchant_1.reload

      expect(@merchant_1.status).to eq('disabled')

      within "#merch-#{@merchant_1.id}" do
        expect(page).not_to have_button "Disable #{@merchant_1.name}"
        click_button "Enable #{@merchant_1.name}"
      end
      expect(current_path).to eq(admin_merchants_path)

      @merchant_1.reload

      expect(@merchant_1.status).to eq('enabled')
    end

    it 'has enabled and disabled merchants' do
      within '#enabled' do
        expect(page).to have_content(@merchant_1.name)
        expect(page).to have_content(@merchant_2.name)
        expect(page).to have_content(@merchant_3.name)

        expect(page).not_to have_content(@merchant_4.name)
        expect(page).not_to have_content(@merchant_5.name)
      end
    end
  end
end
