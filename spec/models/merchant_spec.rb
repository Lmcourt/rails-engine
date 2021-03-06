require 'rails_helper'

RSpec.describe Merchant do

  describe 'relationships' do
    it { should have_many(:items) }
    it { should have_many(:invoice_items).through(:items)}
    it { should have_many(:invoices) }
    it { should have_many(:customers).through(:invoices)}
    it { should have_many(:transactions).through(:invoices)}
  end
  describe 'class methods' do
    before :each do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @merchant2 = Merchant.create!(name: 'Jewelry')
      @merchant3 = Merchant.create!(name: 'Office Space')
      @merchant4 = Merchant.create!(name: 'The Office')

      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id)
      @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant2.id)
      @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant3.id)
      @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant4.id)

      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @customer_2 = Customer.create!(first_name: 'Cecilia', last_name: 'Jones')
      @customer_3 = Customer.create!(first_name: 'Mariah', last_name: 'Carrey')
      @customer_4 = Customer.create!(first_name: 'Leigh Ann', last_name: 'Bron')

      @invoice_1 = Invoice.create!(merchant_id: @merchant1.id, customer_id: @customer_1.id, status: 'shipped')
      @invoice_2 = @merchant2.invoices.create!(customer_id: @customer_2.id, status: 'shipped')
      @invoice_3 = @merchant3.invoices.create!(customer_id: @customer_3.id, status: 'shipped')
      @invoice_4 = @merchant4.invoices.create!(customer_id: @customer_4.id, status: 'shipped')

      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 1, unit_price: 1, created_at: "2012-03-27 14:54:09")
      @ii_2 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_2.id, quantity: 1, unit_price: 2, created_at: "2012-03-29 14:54:09")
      @ii_3 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_3.id, quantity: 1, unit_price: 3, created_at: "2012-03-28 14:54:09")
      @ii_4 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_4.id, quantity: 1, unit_price: 4, created_at: "2012-03-30 14:54:09")

      @transaction1 = Transaction.create!(credit_card_number: 203942, result: 'success', invoice_id: @invoice_1.id)
      @transaction2 = Transaction.create!(credit_card_number: 230948, result: 'success', invoice_id: @invoice_2.id)
      @transaction3 = Transaction.create!(credit_card_number: 234092, result: 'success', invoice_id: @invoice_3.id)
      @transaction4 = Transaction.create!(credit_card_number: 230429, result: 'success', invoice_id: @invoice_4.id)

    end

    it 'finds a quantity of merchants sorted by descending revenue' do
      expect(Merchant.ordered_total_revenue(4)).to eq([@merchant4, @merchant3, @merchant2, @merchant1])
    end

    it 'finds a specific merchants revenue' do
      # result = @merchant1.merchant_total_revenue
      # require "pry"; binding.pry
      expect(Merchant.merchant_total_revenue(@merchant1.id).revenue).to eq(1)
    end
  end
end
