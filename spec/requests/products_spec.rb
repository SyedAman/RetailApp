require 'rails_helper'

RSpec.describe "Products", type: :request do
  # Tests for GET /api/products (Listing active products)
  describe "GET /api/products" do
    before do
      FactoryBot.create_list(:product, 5, status: true)
      FactoryBot.create_list(:product, 3, status: false) # Inactive products for control group
    end

    it "lists only active products" do
      get '/api/products'
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).size).to eq(5)
    end

    it "is sorted by the latest first" do
      get '/api/products'
      expect(response).to have_http_status(200)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response.first['created_at'] > parsed_response.last['created_at']).to be_truthy
    end
  end

  # Tests for GET /api/products/search (Searching products)
  describe "GET /api/products/search" do
    let!(:product) { FactoryBot.create(:product, name: 'SearchMe', price: 500, created_at: 1.day.ago, status: true) }

    it "returns products matching the search criteria" do
      get '/api/products/search', params: { productName: 'SearchMe', minPrice: 400, maxPrice: 600, minPostedDate: 2.days.ago, maxPostedDate: Date.today }
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).length).to eq(1)
      expect(JSON.parse(response.body).first['name']).to eq('SearchMe')
    end

    it "searches products by name only" do
      FactoryBot.create(:product, name: 'Special', status: true)
      get '/api/products/search', params: { productName: 'Special' }
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).first['name']).to eq('Special')
    end

    it "searches products by price only" do
      FactoryBot.create(:product, price: 1000, status: true)
      FactoryBot.create(:product, price: 800, status: true)  # Product with price outside the search range
      FactoryBot.create(:product, price: 1200, status: true) # Product with price outside the search range

      get '/api/products/search', params: { minPrice: 900, maxPrice: 1100 }

      expect(response).to have_http_status(200)

      parsed_response = JSON.parse(response.body)

      # Check that the response includes the product with price 1000
      expect(parsed_response.any? { |product| product['price'].to_f == 1000.0 }).to be_truthy

      # Check that the response does not include the products with prices 800 and 1200
      expect(parsed_response.any? { |product| product['price'].to_f == 800.0 }).to be_falsey
      expect(parsed_response.any? { |product| product['price'].to_f == 1200.0 }).to be_falsey
    end
  end

  # Test for creating a product
  describe "POST /api/products" do
    let(:valid_attributes) { { name: 'New Product', price: 500, status: true } }
    let(:invalid_attributes) { { name: '', price: 15000, status: true } }

    context "with valid parameters" do
      it "creates a new Product" do
        expect {
          post '/api/products', params: { product: valid_attributes }
        }.to change(Product, :count).by(1)
        expect(response).to have_http_status(201)
      end
    end

    context "with invalid parameters" do
      it "does not create a new Product" do
        expect {
          post '/api/products', params: { product: invalid_attributes }
        }.to change(Product, :count).by(0)
        expect(response).to have_http_status(422)
      end
    end
  end

  # Add more tests for update, delete, and approval queue endpoints
end
