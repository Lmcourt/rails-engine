class Api::V1::Revenue::MerchantsController < ApplicationController

  def merchants_most_revenue
    merchants = Merchant.ordered_total_revenue(params[:quantity])
    render json: MerchantNameRevenueSerializer.new(merchants)

    raise ActionController::BadRequest unless params[:quantity]
  end

  def merchant_revenue
    validate_merchant
    merchant = Merchant.find(params[:merchant_id])
    render json: MerchantRevenueSerializer.new(merchant)
  end

  private
  def validate_merchant
    if params[:merchant_id]
      merchant = Merchant.find_by(id: params[:merchant_id])
      raise ActiveRecord::RecordNotFound unless merchant
    end
  end
end
