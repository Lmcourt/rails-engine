class Api::V1::ItemsController < ApplicationController

  def index
    render json: ItemSerializer.new(all_items)
  end

  def show
    item = Item.find(params[:id])
    render json: ItemSerializer.new(item)
  end

  def create
    item = Item.create!(item_params)
    render json: ItemSerializer.new(item), status: 201
  end

  def update
    item = Item.update(params[:id], item_params)
    render json: ItemSerializer.new(item)
  end

  def destroy
    item = Item.destroy(params[:id])
  end

  private

  def all_items
    if params[:merchant_id]
      Merchant.find(params[:merchant_id]).items
    else
      Item.offset(per_page * page).limit(per_page)
    end
  end

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
