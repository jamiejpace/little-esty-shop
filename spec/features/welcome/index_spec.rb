require 'rails_helper'

RSpec.describe 'Welcome index' do
  it 'has name of store' do
    visit root_path
    
    expect(current_path).to eq(root_path)
    expect(page).to have_content("Besty Esty Shop")
  end
end
