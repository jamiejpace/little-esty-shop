class MerchantsController < ApplicationController
  def show
    @merchant = Merchant.find(params[:merchant_id])
    @customers = Invoice.merchant_fav_customers(@merchant)
    @items = Item.merch_items_ship_ready(@merchant)
  end
end
