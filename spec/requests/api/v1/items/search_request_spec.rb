require 'rails_helper'

describe 'Item search' do
  describe 'find by name' do
    it 'finds item by name' do
      merch = create(:merchant)
      item1 = create(:item, name: "Item 1", merchant: merch)
      item2 = create(:item, name: 'thats stuff', merchant: merch)
      item3 = create(:item, name: 'thats an item', merchant: merch)

      get '/api/v1/items/find_all?name=that'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(2)
      expect(items[:data]).to be_a(Array)
    end
  end

  describe 'find by price' do
    it 'finds all items with min price' do
      merch = create(:merchant)
      item1 = create(:item, unit_price: 52, merchant: merch)
      item2 = create(:item, unit_price: 30, merchant: merch)
      item3 = create(:item, unit_price: 60, merchant: merch)

      get '/api/v1/items/find_all?min_price=50'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(2)
      expect(items[:data]).to be_a(Array)
    end

    it 'finds all items with max price' do
      merch = create(:merchant)
      item1 = create(:item, unit_price: 52, merchant: merch)
      item2 = create(:item, unit_price: 30, merchant: merch)
      item3 = create(:item, unit_price: 20, merchant: merch)
      item4 = create(:item, unit_price: 10, merchant: merch)

      get '/api/v1/items/find_all?max_price=50'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(3)
      expect(items[:data]).to be_a(Array)
    end

    it 'finds all items with min and max price' do
      merch = create(:merchant)

      item1 = create(:item, unit_price: 52, merchant: merch)
      item2 = create(:item, unit_price: 30, merchant: merch)
      item3 = create(:item, unit_price: 20, merchant: merch)
      item4 = create(:item, unit_price: 1, merchant: merch)

      get '/api/v1/items/find_all?min_price=10&max_price=50'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(2)
      expect(items[:data]).to be_a(Array)
    end
  end
end
