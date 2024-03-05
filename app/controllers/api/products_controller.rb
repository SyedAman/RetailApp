class Api::ProductsController < ApplicationController
  before_action :set_product, only: [:update, :destroy]

  def index
    @products = Product.where(status: true).order(created_at: :desc)
    render json: @products
  end

  def search
    # Initialize an ActiveRecord::Relation object for products
    query = Product.all

    # Filter by parameters if they exist
    query = query.where('name LIKE ?', "%#{params[:productName]}%") if params[:productName].present?
    query = query.where('price >= ?', params[:minPrice]) if params[:minPrice].present?
    query = query.where('price <= ?', params[:maxPrice]) if params[:maxPrice].present?
    query = query.where('created_at >= ?', params[:minPostedDate]) if params[:minPostedDate].present?
    query = query.where('created_at <= ?', params[:maxPostedDate]) if params[:maxPostedDate].present?

    render json: query
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      if @product.price > 5000
        ApprovalQueue.create(product: @product, request_date: Time.current)
      end
      render json: @product, status: :created
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      render json: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    head :no_content
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :price, :status)
  end
end
