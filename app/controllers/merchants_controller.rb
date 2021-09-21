# frozen_string_literal: true

class MerchantsController < ApplicationController
  def show
    @merchant = Merchant.find(params[:merchant_id])
    @customers = @merchant.fav_customers
    @items = @merchant.items_ready_to_ship
  end
end
