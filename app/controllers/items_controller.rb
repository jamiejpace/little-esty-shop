class ItemsController < ApplicationController
  before_action :current_merchant
  before_action :current_item, except: [:index, :new, :create]

  def index
    @items = @merchant.items
  end

  def show
  end

  def new
    @item = Item.new
  end

  def create
    item = Item.new(item_params.merge({id: Item.next_id, merchant_id: params[:merchant_id]}))
    if item.save
      redirect_to merchant_items_path(@merchant)
    end
  end

  def edit
  end

  def update
    if @item.update(item_params)
      flash[:success] = "Successfully Updated Item"
      updates_redirect_location
    else
      flash[:alert] = "Do Better"
      redirect_to edit_merchant_item_path(@merchant, @item)
    end
  end

  private

  def updates_redirect_location
    if params[:item][:status].present?
      redirect_to merchant_items_path(@merchant)
    else
      redirect_to merchant_item_path(@merchant, @item)
    end
  end

  def current_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :status)
  end
end
