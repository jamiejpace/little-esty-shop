require 'rails_helper'

RSpec.describe 'bulk discount new page' do
  before :each do
    @merchant1 = create :merchant
    @data = {name: "Columbus Day"}
    @holiday1 = Holiday.new(@data)
  end

  it 'has a form to create new discount' do
    visit merchant_bulk_discounts_path(@merchant1)

    click_link "Create Bulk Discount"

    expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant1))
    expect(page).to_not have_content("Discount Percentage: 20")

    fill_in 'Percentage discount', with: '20'
    fill_in 'Quantity threshold', with: '20'

    click_button 'Submit'

    @merchant1.reload
    save_and_open_page
    expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))
    expect(page).to have_content("Discount Percentage: 20")
    expect(page).to have_content(BulkDiscount.last.quantity_threshold)
    expect(page).to have_content("Successfully Created Discount")
  end

  it 'has a sad path for new discount form' do
    visit merchant_bulk_discounts_path(@merchant1)

    click_link "Create Bulk Discount"

    expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant1))
    expect(page).to_not have_content("Discount Percentage: 20")

    fill_in 'Percentage discount', with: nil
    fill_in 'Quantity threshold', with: nil

    click_button 'Submit'

    expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant1))
    expect(page).to have_content("Unable to Create New Discount - Please Try Again")
  end
end
