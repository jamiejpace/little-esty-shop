class InvoicesController < ApplicationController
  before_action :current_merchant

  def index
    @invoices = Invoice.for_merchant(@merchant)
  end

  def show
    @invoice = Invoice.find(params[:id])
    @invoice_items = @invoice.invoice_items
  end

  private
  def current_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end
