class Api::V1::Merchants::SearchController < ApplicationController
  def find
    merchant = Merchant.search_by_name(params[:name]).first
    if merchant
      render json: MerchantSerializer.new(merchant)
    else
      render json: { data: {
        message: 'Merchant not found',
        status: 400
        } }
    end
  end
end
