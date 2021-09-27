require 'rails_helper'

RSpec.describe 'bulk discount show page' do
  before :each do
    @merchant1 = create :merchant
    @discount1 = BulkDiscount.create!(name: "Bulk Discount A", merchant_id: @merchant1.id, percentage_discount: 10, quantity_threshold: 20)
    visit merchant_bulk_discount_path(@merchant1, @discount1)
  end

  it 'lists the quantity threshold and percentage discount' do
    expect(page).to have_content(@discount1.name)
    expect(page).to have_content(@discount1.percentage_discount)
    expect(page).to have_content(@discount1.quantity_threshold)
  end

  it 'has a link to edit the bulk discount' do
    click_link "Edit Discount"

    expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant1, @discount1))
  end
  
end
