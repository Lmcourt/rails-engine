class Api::V1::Items::SearchController < ApplicationController
  def find_all
    if params[:name]
      search = Item.search_by_name(params[:name])
    elsif params[:min_price] && params[:max_price]
      search = Item.price_range(params[:min_price], params[:max_price])
    elsif params[:min_price]
      search = Item.search_by_min_price(params[:min_price])
    elsif params[:max_price]
      search = Item.search_by_max_price(params[:max_price])
    end
    render json: ItemSerializer.new(search)
  end
end
