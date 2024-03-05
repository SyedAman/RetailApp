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

  # Tests for POST /api/products (Creating a product)
  describe "POST /api/products" do
    context "when product price is below $5000" do
      let(:valid_attributes) { { name: 'Affordable', price: 3000, status: true } }

      it "creates a new product without adding to approval queue" do
        expect {
          post '/api/products', params: { product: valid_attributes }
        }.to change(Product, :count).by(1).and change(ApprovalQueue, :count).by(0)
        expect(response).to have_http_status(201)
      end
    end

    context "when product price is above $5000" do
      let(:expensive_attributes) { { name: 'Expensive', price: 6000, status: true } }

      it "creates a new product and adds it to the approval queue" do
        expect {
          post '/api/products', params: { product: expensive_attributes }
        }.to change(Product, :count).by(1).and change(ApprovalQueue, :count).by(1)
        expect(response).to have_http_status(201)
      end
    end
  end

  # Tests for GET /api/products/approval-queue (Listing products in the approval queue)
  describe "GET /api/products/approval-queue" do
    before do
      products = FactoryBot.create_list(:product, 3, price: 6000) # These should be in the approval queue
      products.each { |product| FactoryBot.create(:approval_queue, product: product) }
    end

    it "returns all products in the approval queue" do
      get '/api/products/approval-queue'
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  # Tests for PUT /api/products/approval-queue/:approvalId/approve (Approving a product)
  describe "PUT /api/products/approval-queue/:approvalId/approve" do
    let!(:product_in_queue) { FactoryBot.create(:product, price: 7000) }
    let!(:approval_queue_entry) { FactoryBot.create(:approval_queue, product: product_in_queue) }

    it "approves the product and removes it from the approval queue" do
      expect {
        put "/api/products/approval-queue/#{approval_queue_entry.id}/approve"
      }.to change { ApprovalQueue.count }.by(-1)
      expect(response).to have_http_status(200)
      product_in_queue.reload
      expect(product_in_queue.status).to be_truthy # Assuming status true means approved
    end
  end

  # Tests for PUT /api/products/approval-queue/:approvalId/reject (Rejecting a product)
  describe "PUT /api/products/approval-queue/:approvalId/reject" do
    let!(:product_in_queue) { FactoryBot.create(:product, price: 7000) }
    let!(:approval_queue_entry) { FactoryBot.create(:approval_queue, product: product_in_queue) }

    it "rejects the product and removes it from the approval queue" do
      expect {
        put "/api/products/approval-queue/#{approval_queue_entry.id}/reject"
      }.to change { ApprovalQueue.count }.by(-1)
      expect(response).to have_http_status(200)
      # Ensure the product status is unchanged; adjust as per your application logic
    end
  end


  # @TODO: Add more tests for update, delete, and approval queue endpoints
end
