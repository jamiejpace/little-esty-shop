require 'rails_helper'
# rspec spec/features/items/new_spec.rb
RSpec.describe 'Merchant Items Create New Page' do
  describe 'Merchant Items Create New Page' do
    before :each do
      @merchant = create :merchant
      @item1 = create :item, { merchant_id: @merchant.id }
      visit new_merchant_item_path(@merchant)
    end

    it 'has a form to create new item' do
      within '#form' do
        expect(page).to have_content('Name')
        expect(page).to have_content('Description')
        expect(page).to have_content('Unit price')
        expect(page).to have_button('Submit')
      end
    end

      it 'redirects to merchant item index with new item disabled' do
        fill_in "Name", with: "Best Item Ever"
        fill_in "Description", with: "Best Description Ever"
        fill_in "Unit price", with: 10

        click_button 'Submit'
        @merchant.reload

        expect(current_path).to eq(merchant_items_path(@merchant))
        expect(Item.last.name).to eq("Best Item Ever")
        expect(page).to have_content("Best Item Ever")
        expect(Item.last.status).to eq('disabled')
    end
  end
end
