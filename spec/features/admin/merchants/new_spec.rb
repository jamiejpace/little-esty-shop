require 'rails_helper'

RSpec.describe 'Admin Merchant new' do
  before :each do
    visit new_admin_merchant_path
  end

  it 'can make a new merchant' do
    merchant = create(:merchant)
    fill_in 'Name', with: "Lisa Miller"
    click_button 'Submit'

    expect(current_path).to eq(admin_merchants_path)
    expect(Merchant.last.name).to eq("Lisa Miller")
    expect(page).to have_content("Lisa Miller")
  end

end
