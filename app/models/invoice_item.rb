class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  has_one :merchant, through: :item
  # 
  # enum status: [:pending, :packaged, :shipped]
end
