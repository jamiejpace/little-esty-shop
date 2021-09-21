require 'rails_helper'

RSpec.describe 'Admin Merchant Index' do
  describe 'index page' do
    before :each do
      @merchant_1 = create(:merchant)
      @merchant_2 = create(:merchant)
      @merchant_3 = create(:merchant)
      @merchant_4 = create(:merchant, { status: 'enabled' })
      @merchant_5 = create(:merchant, { status: 'enabled' })
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
      expect(page).to have_button('Enable', count: 3)
    end

    it 'changes button dynamically when enable/disabled clicked' do
      within "#merch-#{@merchant_1.id}" do
        expect(page).not_to have_button "Disable #{@merchant_1.name}"
        click_button "Enable #{@merchant_1.name}"
      end

      expect(current_path).to eq(admin_merchants_path)
      @merchant_1.reload

      expect(@merchant_1.status).to eq('enabled')

      within "#merch-#{@merchant_1.id}" do
        expect(page).not_to have_button "Enable #{@merchant_1.name}"
        click_button "Disable #{@merchant_1.name}"
      end
      expect(current_path).to eq(admin_merchants_path)

      @merchant_1.reload

      expect(@merchant_1.status).to eq('disabled')
    end

    it 'has enabled and disabled merchants' do
      within '#enabled' do
        expect(page).not_to have_content(@merchant_1.name)
        expect(page).not_to have_content(@merchant_2.name)
        expect(page).not_to have_content(@merchant_3.name)

        expect(page).to have_content(@merchant_4.name)
        expect(page).to have_content(@merchant_5.name)
      end
    end

    it 'has a link to create a merchant' do
      click_on "Create New Merchant"
      expect(current_path).to eq(new_admin_merchant_path)
    end

    it 'has top_five merchants by revenue' do
      merch1 = double('merchant')
      merch2 = double('merchant')
      merch3 = double('merchant')
      merch4 = double('merchant')
      merch5 = double('merchant')
      allow(merch1).to receive(:name).and_return('Chuck')
      allow(merch2).to receive(:name).and_return('Jamie')
      allow(merch3).to receive(:name).and_return('Christina')
      allow(merch4).to receive(:name).and_return('Carmen')
      allow(merch5).to receive(:name).and_return('Sandiago')
      allow(merch1).to receive(:revenue).and_return(100)
      allow(merch2).to receive(:revenue).and_return(200)
      allow(merch3).to receive(:revenue).and_return(300)
      allow(merch4).to receive(:revenue).and_return(400)
      allow(merch5).to receive(:revenue).and_return(500)
      allow(merch1).to receive(:date).and_return(DateTime.new(2021, 1, 1))
      allow(merch2).to receive(:date).and_return(DateTime.new(2021, 1, 1))
      allow(merch3).to receive(:date).and_return(DateTime.new(2021, 1, 1))
      allow(merch4).to receive(:date).and_return(DateTime.new(2021, 1, 1))
      allow(merch5).to receive(:date).and_return(DateTime.new(2021, 1, 1))

      allow(Merchant).to receive(:top_five_merchants).and_return([merch5, merch4, merch3, merch2, merch1])

      visit admin_merchants_path

      within '#top-merchants' do
        [merch5, merch4, merch3, merch2, merch1].each do |merch|
          within "#merch-#{merch.name}"
          expect(page).to have_content(merch.name)
          expect(page).to have_content("$#{merch.revenue / 100}.00")
          expect(page).to have_content(merch.date.strftime('%b%e, %Y'))
        end
      end
    end
  end
end
