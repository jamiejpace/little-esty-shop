# frozen_string_literal: true

class BulkDiscountsController < ApplicationController
  before_action :current_merchant

  def index
    @bulk_discounts = BulkDiscount.all
    @holidays = BulkDiscountFacade.holidays
  end
end
