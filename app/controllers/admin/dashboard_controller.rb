class Admin::DashboardController < ApplicationController
  def index
    @top_customers = Customer.top_5_customers
    @pending_invoices = Invoice.pending_invoices
  end
end
