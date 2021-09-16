class MerchantsController < ApplicationController
  def show
    @merchant = Merchant.find(params[:merchant_id])
    @fav_customers = Invoice.merchant_fav_customers(@merchant)
  end
end
