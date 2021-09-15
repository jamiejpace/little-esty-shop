require 'rails_helper'

RSpec.describe 'Admin Merchant Show' do
  before :each do
    @merchant_1 = create(:merchant)
    visit admin_merchant_path(@merchant_1)
  end

  it "has the merchant's name" do
    expect(page).to have_content(@merchant_1.name)
  end
end
