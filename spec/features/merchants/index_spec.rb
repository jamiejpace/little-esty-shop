require 'rails_helper'
# rspec spec/features/merchants/index_spec.rb
RSpec.describe 'Merchant Items Index Page' do
  describe 'Merchant Items Index Page' do
    before :each do
      @merchant = create :merchant
      @merchant2 = create :merchant
      @item1 = create :item, { merchant_id: @merchant.id }
      @item2 = create :item, { merchant_id: @merchant.id }
      @item3 = create :item, { merchant_id: @merchant2.id }
      visit merchant_items_path(@merchant)
    end

    it 'lists all item names' do
      expect(page).to have_content(@item1.name)
      expect(page).to have_content(@item2.name)
      expect(page).to have_no_content(@item3.name)
    end

    it 'links items to show page' do
      click_link @item1.name

      expect(current_path).to eq(merchant_item_path(@merchant, @item1))
    end
  end
end
