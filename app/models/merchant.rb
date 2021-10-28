class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  def self.ordered_total_revenue(quantity)
    joins(invoices: :transactions)
    .where(invoices: {status: 'shipped'}, transactions: {result: 'success'})
    .select('merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) AS revenue')
    .group(:id)
    .order('revenue DESC')
    .limit(quantity)

  end

  def self.merchant_total_revenue(merch)
    joins(invoices: :transactions)
    .where('merchants.id = ? AND result = ?', merch, 'success')
    .select('merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) AS revenue')
    .group(:id)
    .first
  end

  def self.most_items(quantity = 5)
    joins(invoices: :transactions)
    .where('result = ?', 'success')
    .select('merchants.*, sum(invoice_items.quantity) AS count')
    .group(:id)
    .order('count DESC')
    .limit(quantity)
  end
end
