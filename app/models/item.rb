class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true

  def self.search_by_min_price(price)
    where('unit_price >= ?', price)
  end

  def self.search_by_max_price(price)
    where('unit_price <= ?', price)
  end

  def self.price_range(min, max)
    merge(Item.search_by_min_price(min))
    .merge(Item.search_by_max_price(max))
  end

  def self.top_items_by_revenue(quantity = 10)
      joins(invoices: :transactions)
      .where(transactions: {result: :success})
      .group('items.id')
      .select('items.*, sum(invoice_items.quantity * invoice_items.unit_price) AS revenue')
      .order(revenue: :desc)
      .limit(quantity)
  end
end
