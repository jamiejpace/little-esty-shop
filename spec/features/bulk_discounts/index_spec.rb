require 'rails_helper'

RSpec.describe 'bulk discount index page' do
  before :each do
    @merchant1 = create :merchant
    @merchant2 = create :merchant
    @discount1 = create :bulk_discount, { merchant_id: @merchant1.id, id: 1, name: "Discount A" }
    @discount2 = create :bulk_discount, { merchant_id: @merchant1.id, id: 2, name: "Discount B" }
    @discount3 = create :bulk_discount, { merchant_id: @merchant1.id, id: 3, name: "Discount C" }
    @discount4 = create :bulk_discount, { merchant_id: @merchant1.id, id: 4, name: "Discount D" }
    @discount5 = create :bulk_discount, { merchant_id: @merchant2.id, id: 5, name: "Discount 1" }
    @data = {name: "Columbus Day"}
    @holiday1 = Holiday.new(@data)
    visit merchant_bulk_discounts_path(@merchant1)
  end

  it 'lists all bulk discounts with their percentage discount and quantity threshold' do
    expect(page).to have_content("#{@discount1.percentage_discount}%")
    expect(page).to have_content(@discount1.quantity_threshold)
    expect(page).to have_content("#{@discount2.percentage_discount}%")
    expect(page).to have_content(@discount2.quantity_threshold)
  end

  it 'links to each bulk discount show page' do
    expect(page).to have_link(@discount1.name)
    expect(page).to have_link(@discount2.name)
    expect(page).to have_link(@name)
    expect(page).to have_link(@discount4.name)
    expect(page).to_not have_link(@discount5.name)
  end

  it 'lists the three next US holidays' do
    expect(page).to have_content(@holiday1.name)
  end

  it 'has a link to create a holiday discount next to each holiday' do
    expect(page).to have_link("Create #{@holiday1.name} Discount")
  end

  it 'has a link to create a new merchant discount' do
    click_link "Create Bulk Discount"

    expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant1))
  end

  it 'has a link to delete a discount' do
    within("div#discount-#{@discount1.id}") do
      click_link "Delete Discount"
    end

    expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))

    expect(page).to_not have_content("Discount A")
  end
end
