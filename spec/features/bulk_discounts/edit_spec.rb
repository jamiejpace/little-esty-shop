require 'rails_helper'

RSpec.describe 'bulk discount edit page' do
  before :each do
    @merchant1 = create :merchant
    @discount1 = BulkDiscount.create!(name: "Bulk Discount A", merchant_id: @merchant1.id, percentage_discount: 10, quantity_threshold: 20)
  end

  it 'has a form to edit the discount with prepopulated values' do
    visit edit_merchant_bulk_discount_path(@merchant1.id, @discount1.id)
    expect(page).to have_field('Name', with: @discount1.name)
    expect(page).to have_field('Percentage discount', with: @discount1.percentage_discount)
    expect(page).to have_field('Quantity threshold', with: @discount1.quantity_threshold)


    fill_in 'Name', with: 'Birthday Discount'
    fill_in 'Percentage discount', with: 25
    fill_in 'Quantity threshold', with: 5

    click_button 'Submit'

    expect(current_path).to eq(merchant_bulk_discount_path(@merchant1.id, @discount1.id))
    expect(page).to have_content('Birthday Discount')
    expect(page).to have_content('Successfully Updated Discount')
    expect(page).to have_content(25)
    expect(page).to have_content(5)
  end

  it 'has a form to edit the discount with prepopulated values' do
    visit edit_merchant_bulk_discount_path(@merchant1.id, @discount1.id)

    fill_in 'Name', with: 'Birthday Discount'
    fill_in 'Percentage discount', with: ''
    fill_in 'Quantity threshold', with: ''

    click_button 'Submit'

    expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant1.id, @discount1.id))
    expect(page).to have_content('Could Not Update - Please Try Again')
    expect(page).to_not have_content('Birthday Discount')
  end
end
