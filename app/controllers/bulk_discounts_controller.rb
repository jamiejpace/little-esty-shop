# frozen_string_literal: true

class BulkDiscountsController < ApplicationController
  before_action :current_merchant

  def index
    @bulk_discounts = @merchant.bulk_discounts.all
    @holidays = BulkDiscountFacade.holidays
  end

  def new
  end

  def create
    bulk_discount = @merchant.bulk_discounts.new(bulk_discount_params)
    if bulk_discount.save
      flash[:success] = 'Successfully Created Discount'
      redirect_to merchant_bulk_discounts_path(@merchant)
    else
      flash[:alert] = 'Unable to Create New Discount - Please Try Again'
      redirect_to new_merchant_bulk_discount_path(@merchant)
    end
  end

  def destroy
    BulkDiscount.find(params[:id]).destroy
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  private

  def bulk_discount_params
    params.permit(:name, :percentage_discount, :quantity_threshold)
  end
end
