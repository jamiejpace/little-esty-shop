# frozen_string_literal: true

module Admin
  class DashboardController < Admin::BaseController
    def index
      @top_customers = Customer.top_5_customers
      @pending_invoices = Invoice.pending_invoices
    end
  end
end
