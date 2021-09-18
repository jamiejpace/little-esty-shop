class MerchantsController < ApplicationController
  def show
    @merchant = Merchant.find(params[:merchant_id])
    @customers = @merchant.fav_customers
    @items = Item.merch_items_ship_ready(@merchant)
  end
end
