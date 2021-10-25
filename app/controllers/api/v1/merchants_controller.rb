class Api::V1::MerchantsController < ApplicationController

  def index
    per_page = params.fetch(:per_page, 20).to_i
    if params[:page].to_i > 0
      page = params.fetch(:page, 1).to_i - 1
    else
      page = 0
    end
    merchants = Merchant.offset(per_page * page).limit(per_page)
    render json: MerchantSerializer.new(merchants)
  end
end
