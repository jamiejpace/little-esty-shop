class ItemsController < ApplicationController

  before_action :current_merchant
  before_action :current_item, except: [:index, :new, :create]

  def index
    @items = @merchant.items
  end

  def show
  end

  def edit
  end

  def update
    if params[:item][:status].present?
      @item.update(status: params[:item][:status])
      flash[:success] = "Successfully Updated Item"
      redirect_to merchant_items_path(@merchant)
    elsif @item.update(item_params)
      flash[:success] = "Successfully Updated Item"
      redirect_to merchant_item_path(@merchant, @item)
    else
      flash[:alert] = "Do Better"
      render :edit
    end
  end

  private
  def current_item
    @item = Item.find(params[:id])
  end

  def current_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :status)
  end
end
