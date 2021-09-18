require 'rails_helper'
# rspec spec/features/items/edit_spec.rb
RSpec.describe 'Merchant Items Edit Page' do
  describe 'Merchant Items Edit Page' do
    before :each do
      @merchant = create :merchant
      @item = create :item, { merchant_id: @merchant.id }
      visit edit_merchant_item_path(@merchant, @item)
    end

    it 'has a form to update the item' do
      within '#form' do

        expect(find_field('item_name').value).to eq(@item.name)

        fill_in "Name", with: "Best Item Ever"

        click_button 'Submit'
      end

      expect(current_path).to eq(merchant_item_path(@merchant, @item))
      expect(page).to have_content("Best Item Ever")
      expect(page).to have_content("Successfully Updated Item")
    end

    it 'handles incorrect form submission' do
      within '#form' do

        expect(find_field('item_name').value).to eq(@item.name)

        fill_in "Name", with: ""

        click_button 'Submit'

      end
      
      within '#form' do
          expect(find_field('item_name').value).to eq(@item.name)
      end

      expect(page).to have_content("Do Better")
    end
  end
end
