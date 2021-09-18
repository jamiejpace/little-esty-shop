require 'rails_helper'
# rspec spec/models/invoice_item_spec.rb
RSpec.describe InvoiceItem, type: :model do

  describe 'validations' do
    it { belong_to :item }
    it { belong_to :invoice }
  end

  describe 'enum' do
    let(:status){['pending','packaged','shipped']}
    it 'has the right index' do
      status.each_with_index do |item, index|
        expect(InvoiceItem.statuses[item]).to eq(index)
      end
    end
  end
end
