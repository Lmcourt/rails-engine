class MerchantRevenueSerializer
  include JSONAPI::Serializer
  attribute :revenue do |object|
    object.merchant_total_revenue
  end
end
