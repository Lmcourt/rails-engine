class Api::V1::Merchants::SearchController < ApplicationController
  def find
    search = Merchant.search_by_name(params[:name]).first
    render json: MerchantSerializer.new(search)
  end
end
