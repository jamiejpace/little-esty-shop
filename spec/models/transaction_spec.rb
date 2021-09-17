require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'relationships' do
    let(:results) { ['success', 'failed'] }

    it { should belong_to :invoice}

    it 'has the right index' do
      results.each_with_index do |item, index|
        expect(Transaction.results[item]).to eq(index)
      end
    end
  end
end
