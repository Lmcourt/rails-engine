class Api::V1::Revenue::ItemsController < ApplicationController

  def items_most_revenue
    if params[:quantity].nil?
      items = Item.top_items_by_revenue
    elsif !invalid_params
      items = Item.top_items_by_revenue(params[:quantity])
    else
      raise ActionController::BadRequest if invalid_params
    end
    render json: ItemRevenueSerializer.new(items)
  end

  private
  def invalid_params
    params[:quantity] == '' || !(params[:quantity] !~ /\D/)
  end
end
