require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe 'relationships' do
    it { should have_many :invoices }
  end

  context 'admin stories' do
    describe 'admin dashboard statistics' do
      # customer - invoice - transaction
      let!(:cust1) { create :customer }
      let!(:cust2) { create :customer }
      let!(:cust3) { create :customer }
      let!(:cust4) { create :customer }
      let!(:cust5) { create :customer }
      let!(:cust6) { create :customer }
      let!(:inv1) { create :invoice, { customer_id: cust1.id } }
      let!(:inv2) { create :invoice, { customer_id: cust2.id } }
      let!(:inv3) { create :invoice, { customer_id: cust3.id } }
      let!(:inv4) { create :invoice, { customer_id: cust4.id } }
      let!(:inv5) { create :invoice, { customer_id: cust5.id } }
      let!(:inv6) { create :invoice, { customer_id: cust6.id } }
      let!(:trans1) { create :transaction, { invoice_id: inv1.id, result: 0 } }
      let!(:trans2) { create :transaction, { invoice_id: inv1.id, result: 0 } }
      let!(:trans3) { create :transaction, { invoice_id: inv1.id, result: 0 } }
      let!(:trans4) { create :transaction, { invoice_id: inv1.id, result: 0 } }
      let!(:trans16) { create :transaction, { invoice_id: inv1.id, result: 0 } }
      let!(:trans5) { create :transaction, { invoice_id: inv2.id, result: 0 } }
      let!(:trans6) { create :transaction, { invoice_id: inv2.id, result: 0 } }
      let!(:trans7) { create :transaction, { invoice_id: inv3.id, result: 0 } }
      let!(:trans13) { create :transaction, { invoice_id: inv3.id, result: 0 } }
      let!(:trans15) { create :transaction, { invoice_id: inv3.id, result: 0 } }
      let!(:trans8) { create :transaction, { invoice_id: inv4.id, result: 0 } }
      let!(:trans9) { create :transaction, { invoice_id: inv4.id, result: 0 } }
      let!(:trans10) { create :transaction, { invoice_id: inv4.id, result: 0 } }
      let!(:trans14) { create :transaction, { invoice_id: inv4.id, result: 0 } }
      let!(:trans11) { create :transaction, { invoice_id: inv5.id, result: 0 } }
      let!(:trans12) { create :transaction, { invoice_id: inv6.id, result: 1 } }

      it '#top_5_customers' do
        expect(Customer.top_5_customers).to eq([cust1, cust4, cust3, cust2, cust5])
      end
    end
  end
end
