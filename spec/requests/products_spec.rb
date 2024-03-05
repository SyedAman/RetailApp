require 'rails_helper'

RSpec.describe "Products", type: :request do
  # Test for listing active products
  describe "GET /api/products" do
    it "lists all active products" do
      FactoryBot.create_list(:product, 5, status: true)
      get '/api/products'
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).size).to eq(5)
    end
  end

  # Test for searching products
  describe "GET /api/products/search" do
    it "searches products by name" do
      FactoryBot.create(:product, name: 'Special', status: true)
      get '/api/products/search', params: { productName: 'Special' }
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).first['name']).to eq('Special')
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
