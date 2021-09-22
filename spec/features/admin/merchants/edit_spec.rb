# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin Merchant edit' do
  before :each do
    @merchant = create(:merchant)
    visit edit_admin_merchant_path(@merchant)
  end

  it 'has a form to update the merchant' do
    within '#form' do
      expect(find_field('merchant_name').value).to eq(@merchant.name)

      fill_in 'Name', with: 'Chuck Norris Kicks Your Inc.'
      click_button 'Submit'
    end

    expect(page).to have_content('Chuck Norris Kicks Your Inc.')

    expect(page).to have_content('Successfully updated merchant')

    expect(current_path).to eq(admin_merchant_path(@merchant))
  end

  it 'rejects empty name' do
    within '#form' do
      fill_in 'Name', with: ''
      click_button 'Submit'
    end

    expect(page).to have_content('Invalid name, fool')
    expect(current_path).to eq(edit_admin_merchant_path(@merchant))
  end
end
