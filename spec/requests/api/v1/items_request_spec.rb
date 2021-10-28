require 'rails_helper'

describe 'items API' do
  describe 'all items' do
    it 'can find all items page 1 with 20 per page' do
      merchant = create(:merchant)
      create_list(:item, 50, merchant_id: merchant.id)

      get '/api/v1/items'

      expect(response).to be_successful

      twenty_items = JSON.parse(response.body, symbolize_names: true)

      expect(twenty_items[:data].count).to eq(20)
      expect(twenty_items).to be_a(Hash)
      expect(twenty_items[:data]).to be_a(Array)
      expect(twenty_items[:data][0]).to have_key(:id)
      expect(twenty_items[:data][0]).to have_key(:type)
      expect(twenty_items[:data][0][:type]).to eq("item")
      expect(twenty_items[:data][0][:attributes][:name]).to be_a String
      expect(twenty_items[:data][0][:attributes]).to have_key :name
      expect(twenty_items[:data][0][:attributes]).to have_key :description
      expect(twenty_items[:data][0][:attributes]).to have_key :unit_price
      expect(twenty_items[:data][0][:attributes]).to have_key :merchant_id
    end

    it 'can find all items page 1 with 50 per page' do
      merchant = create(:merchant)
      create_list(:item, 110, merchant_id: merchant.id)

      get '/api/v1/items?per_page=50'

      expect(response).to be_successful

      fifty_items = JSON.parse(response.body, symbolize_names: true)

      expect(fifty_items[:data].count).to eq(50)
      expect(fifty_items).to be_a(Hash)
      expect(fifty_items[:data]).to be_a(Array)
      expect(fifty_items[:data][0]).to have_key(:id)
      expect(fifty_items[:data][0]).to have_key(:type)
      expect(fifty_items[:data][0][:type]).to eq("item")
      expect(fifty_items[:data][0][:attributes][:name]).to be_a String
      expect(fifty_items[:data][0][:attributes]).to have_key :name
      expect(fifty_items[:data][0][:attributes]).to have_key :description
      expect(fifty_items[:data][0][:attributes]).to have_key :unit_price
      expect(fifty_items[:data][0][:attributes]).to have_key :merchant_id
    end

    it 'fetches page 1 if page is 0 or lower' do
      merchant = create(:merchant)
      create_list(:item, 110, merchant_id: merchant.id)

      get '/api/v1/items?page=0'

      expect(response).to be_successful

      fifty_items = JSON.parse(response.body, symbolize_names: true)

      expect(fifty_items[:data].count).to eq(20)
      expect(fifty_items).to be_a(Hash)
      expect(fifty_items[:data]).to be_a(Array)
      expect(fifty_items[:data][0]).to have_key(:id)
      expect(fifty_items[:data][0]).to have_key(:type)
      expect(fifty_items[:data][0][:type]).to eq("item")
      expect(fifty_items[:data][0][:attributes][:name]).to be_a String
      expect(fifty_items[:data][0][:attributes]).to have_key :name
      expect(fifty_items[:data][0][:attributes]).to have_key :description
      expect(fifty_items[:data][0][:attributes]).to have_key :unit_price
      expect(fifty_items[:data][0][:attributes]).to have_key :merchant_id
    end
  end

  describe 'one item' do
    it 'gets one item by id' do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)

      get "/api/v1/items/#{item.id}"

      expect(response).to be_successful

      item = JSON.parse(response.body, symbolize_names: true)

      expect(item.count).to eq(1)
      expect(item).to be_a Hash
      expect(item[:data]).to have_key :id
      expect(item[:data]).to have_key :type
      expect(item[:data]).to have_key :attributes
      expect(item[:data][:attributes]).to have_key :name
      expect(item[:data][:attributes]).to have_key :description
      expect(item[:data][:attributes]).to have_key :unit_price
      expect(item[:data][:attributes]).to have_key :merchant_id
      expect(item[:data][:attributes][:name]).to be_a String
    end

    it 'sends 404 error if id is not valid integer' do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)

      get "/api/v1/items/1"

      expect(response).to_not be_successful
      expect(response).to have_http_status(404)
    end

    it 'sends 404 error if id is a string' do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)

      get "/api/v1/items/one"

      expect(response).to_not be_successful
      expect(response).to have_http_status(404)
    end
  end

  describe 'creating an item' do
    it 'can create a new item' do
      merchant = create(:merchant)
      item_params = ({
                    name: "new item",
                    description: "its a really good item. You want this.",
                    unit_price: 55.55,
                    merchant_id: merchant.id
                    })
      headers = {"CONTENT_TYPE" => "application/json"}

      post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

      created_item = Item.last

      expect(response).to be_successful
      expect(created_item.name).to eq(item_params[:name])
      expect(created_item.description).to eq(item_params[:description])
      expect(created_item.unit_price).to eq(item_params[:unit_price])
      expect(created_item.merchant_id).to eq(item_params[:merchant_id])
      expect(response).to have_http_status(201)

    end

    it 'returns an error if any attribute is missing' do
      merchant = create(:merchant)
      item_params = ({
                    name: "new item",
                    description: "its a really good item. You want this.",
                    unit_price: 55.55,
                    })
      headers = {"CONTENT_TYPE" => "application/json"}

      post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

      created_item = Item.last

      expect(response).to_not be_successful
      expect(response).to have_http_status(422)
    end

    it 'ignores any attributes sent by the user which are not allowed' do
      merchant = create(:merchant)
      item_params = ({
                    name: "new item",
                    description: "its a really good item. You want this.",
                    unit_price: 55.55,
                    merchant_id: merchant.id,
                    other: "not a real attribute"
                    })
      headers = {"CONTENT_TYPE" => "application/json"}

      post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

      created_item = Item.last

      expect(response).to be_successful
      expect(created_item.name).to eq(item_params[:name])
      expect(created_item.description).to eq(item_params[:description])
      expect(created_item.unit_price).to eq(item_params[:unit_price])
      expect(created_item.merchant_id).to eq(item_params[:merchant_id])
    end
  end

  describe 'editing an item' do
    it 'updates an existing item' do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)
      previous_name = Item.last.name
      item_params = { name: "This is the updated name" }
      headers = { "CONTENT_TYPE" => "application/json" }

      patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate({item: item_params})
      item = Item.find_by(id: item.id)

      expect(response).to be_successful
      expect(item.name).to_not eq(previous_name)
      expect(item.name).to eq("This is the updated name")
    end
  end

  describe 'destroys an item' do
    it 'destroys an existing item' do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)

      expect(Item.count).to eq(1)

      delete "/api/v1/items/#{item.id}"

      expect(response).to be_successful
      expect(Item.count).to eq(0)
      expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
      expect(response).to have_http_status(204)
    end
  end

  describe 'get the merchant data for a given item ID' do
    it 'finds a merchant by item ID' do
      merch = create(:merchant)
      item = create(:item, merchant_id: merch.id)

      get "/api/v1/items/#{item.id}/merchant"

      expect(response).to be_successful

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(merchant[:data][:attributes]).to have_key(:name)
      expect(merchant[:data][:id].to_i).to eq(merch.id)
      expect(response).to have_http_status(200)
    end
  end
end
