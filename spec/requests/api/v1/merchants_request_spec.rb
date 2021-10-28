require 'rails_helper'

describe 'Merchants API' do
  describe 'all merchants' do
    it 'gets all merchants, a default of 20 at a time' do

      create_list(:merchant, 50)

      get '/api/v1/merchants'

      expect(response).to be_successful

      twenty_merchants = JSON.parse(response.body, symbolize_names: true)

      expect(twenty_merchants[:data].count).to eq(20)
      expect(twenty_merchants).to be_a(Hash)
      expect(twenty_merchants[:data]).to be_a(Array)
      expect(twenty_merchants[:data][0]).to have_key(:id)
      expect(twenty_merchants[:data][0]).to have_key(:type)
      expect(twenty_merchants[:data][0][:type]).to eq("merchant")
      expect(twenty_merchants[:data][0][:attributes][:name]).to be_a String
      expect(twenty_merchants[:data][0][:attributes]).to have_key :name
    end

    it 'gets second page of merchants 20 at a time' do
      create_list(:merchant, 50)

      get '/api/v1/merchants?page=2'

      expect(response).to be_successful

      twenty_merchants = JSON.parse(response.body, symbolize_names: true)

      expect(twenty_merchants[:data].count).to eq(20)
      expect(twenty_merchants).to be_a(Hash)
      expect(twenty_merchants[:data]).to be_a(Array)
      expect(twenty_merchants[:data][0]).to have_key(:id)
      expect(twenty_merchants[:data][0]).to have_key(:type)
      expect(twenty_merchants[:data][0][:type]).to eq("merchant")
      expect(twenty_merchants[:data][0][:attributes][:name]).to be_a String
      expect(twenty_merchants[:data][0][:attributes]).to have_key :name
    end

    it 'gets second page of merchants 50 at a time' do
      create_list(:merchant, 110)

      get '/api/v1/merchants?per_page=50&page=2'

      expect(response).to be_successful

      fifty_merchants = JSON.parse(response.body, symbolize_names: true)

      expect(fifty_merchants[:data].count).to eq(50)
      expect(fifty_merchants).to be_a(Hash)
      expect(fifty_merchants[:data]).to be_a(Array)
      expect(fifty_merchants[:data][0]).to have_key(:id)
      expect(fifty_merchants[:data][0]).to have_key(:type)
      expect(fifty_merchants[:data][0][:type]).to eq("merchant")
      expect(fifty_merchants[:data][0][:attributes][:name]).to be_a String
      expect(fifty_merchants[:data][0][:attributes]).to have_key :name
    end

    it 'fetches page 1 if page is 0 or lower' do
      create_list(:merchant, 50)

      get '/api/v1/merchants?page=0'

      expect(response).to be_successful

      fifty_merchants = JSON.parse(response.body, symbolize_names: true)

      expect(fifty_merchants[:data].count).to eq(20)
      expect(fifty_merchants).to be_a(Hash)
      expect(fifty_merchants[:data]).to be_a(Array)

      get '/api/v1/merchants?page=-5'
      expect(response).to be_successful

      fifty_merchants = JSON.parse(response.body, symbolize_names: true)
      expect(fifty_merchants[:data].count).to eq(20)

    end

    it 'always return an array of data, even if one or zero resources are found' do
      create(:merchant)

      get '/api/v1/merchants'

      expect(response).to be_successful

      fifty_merchants = JSON.parse(response.body, symbolize_names: true)

      expect(fifty_merchants[:data].count).to eq(1)
      expect(fifty_merchants[:data]).to be_a(Array)
    end
  end

  describe 'one merchant' do
    it 'gets one merchant by id' do
      merchant = create(:merchant)

      get "/api/v1/merchants/#{merchant.id}"

      expect(response).to be_successful

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(merchant).to be_a(Hash)
      expect(merchant[:data]).to be_a(Hash)
      expect(merchant[:data]).to have_key(:id)
      expect(merchant[:data]).to have_key(:type)
      expect(merchant[:data][:type]).to eq("merchant")
      expect(merchant[:data][:attributes][:name]).to be_a String
      expect(merchant[:data][:attributes]).to have_key :name
    end

    it 'sends 404 error if id is not valid integer' do
      merchant = create(:merchant)
      get "/api/v1/merchants/1"

      expect(response).to_not be_successful
      expect(response).to have_http_status(404)
    end
  end

  describe 'all merchant items' do
    it 'gets all merchant items' do
      merchant = create(:merchant)
      create_list(:item, 42, merchant_id: merchant.id)

      get "/api/v1/merchants/#{merchant.id}/items"

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(42)
      expect(items).to be_a(Hash)
      expect(items[:data]).to be_a(Array)
      expect(items[:data][0]).to have_key(:id)
      expect(items[:data][0]).to have_key(:type)
      expect(items[:data][0][:type]).to be_a(String)
      expect(items[:data][0]).to have_key(:attributes)
      expect(items[:data][0][:attributes]).to have_key(:name)
      expect(items[:data][0][:attributes]).to have_key(:description)
      expect(items[:data][0][:attributes]).to have_key(:unit_price)
      expect(items[:data][0][:attributes][:name]).to be_a(String)
    end

    it 'returns 404 error if integer is not valid' do
      merchant = create(:merchant)
      create_list(:item, 42, merchant_id: merchant.id)

      get "/api/v1/merchants/5/items"

      expect(response).to_not be_successful
      expect(response).to have_http_status(404)
    end
  end
end
