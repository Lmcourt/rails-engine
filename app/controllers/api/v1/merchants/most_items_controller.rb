class Api::V1::Merchants::MostItemsController < ApplicationController
  def merchant_most_items
    merchants = Merchant.most_items(params[:quantity])
    render json: ItemsSoldSerializer.new(merchants)

    raise ActionController::BadRequest unless params[:quantity]
  end
end
