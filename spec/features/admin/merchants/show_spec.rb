require 'rails_helper'

RSpec.describe 'Admin Merchant Show' do
  before :each do
    @merchant = create(:merchant)
    visit admin_merchant_path(@merchant)
  end

  it "has the merchant's name" do
    expect(page).to have_content(@merchant.name)
  end

  it 'has a button to update the merchant' do
    click_on "Edit Merchant"

    expect(current_path).to eq(edit_admin_merchant_path(@merchant))
  end
end
