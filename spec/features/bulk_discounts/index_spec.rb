require 'rails_helper'

RSpec.describe 'bulk discount index page' do
  before :each do
    @merchant1 = create :merchant
    @discount1 = create :bulk_discount, { merchant_id: @merchant1.id, id: 1 }
    @discount2 = create :bulk_discount, { merchant_id: @merchant1.id, id: 2 }
    @discount3 = create :bulk_discount, { merchant_id: @merchant1.id, id: 3 }
    @discount4 = create :bulk_discount, { merchant_id: @merchant1.id, id: 4 }
  end

  it 'lists all bulk discounts with their percentage discount and quantity threshold' do
    visit merchant_bulk_discounts_path(@merchant1)

    expect(page).to have_content(@discount1.id)
    expect(page).to have_content("#{@discount1.percentage_discount}%")
    expect(page).to have_content(@discount1.quantity_threshold)
  end

  it 'links to each bulk discount show page' do
    visit merchant_bulk_discounts_path(@merchant1)
    
    save_and_open_page
    expect(page).to have_link("Discount #{@discount1.id}")
    expect(page).to have_link("Discount #{@discount2.id}")
    expect(page).to have_link("Discount #{@discount3.id}")
    expect(page).to have_link("Discount #{@discount4.id}")
  end
end
