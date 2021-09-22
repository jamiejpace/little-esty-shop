require 'rails_helper'

RSpec.describe 'merchant index page' do
  describe 'showing merchants' do
    let!(:merchants) { create_list(:merchant, 5) }
    it 'shows all the merchants' do
      visit merchants_path
      merchants.each do |merchant|
        expect(page).to have_content(merchant.name)
      end
    end
  end
end
