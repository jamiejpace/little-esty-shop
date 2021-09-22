require 'rails_helper'
# rspec spec/features/items/show_spec.rb
RSpec.describe 'Merchant Items' do
  describe 'Merchant Items Show Page' do
    before :each do
      @merchant = create :merchant
      @item3 = create :item, { merchant_id: @merchant.id }
      @item1 = create :item, { merchant_id: @merchant.id }
      visit merchant_item_path(@merchant, @item1)
    end

    it 'lists item attributes' do
      expect(page).to have_content(@item1.name)
      expect(page).to have_content(@item1.description)
      expect(page).to have_content(@item1.unit_price.fdiv(100))
      expect(page).to have_no_content(@item3.name)
    end

    it 'links to update item info' do
      expect(page).to have_link('Update')
      click_link 'Update'
      expect(current_path).to eq(edit_merchant_item_path(@merchant, @item1))
    end
  end
end
