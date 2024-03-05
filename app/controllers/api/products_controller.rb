class Api::ProductsController < ApplicationController
  before_action :set_product, only: [:update, :destroy]

  def index
    @products = Product.where(status: true).order(created_at: :desc)
    render json: @products
  end

  def search
    @products = Product.where('name LIKE ? AND price >= ? AND price <= ? AND created_at >= ? AND created_at <= ?',
                              "%#{params[:productName]}%", params[:minPrice], params[:maxPrice],
                              params[:minPostedDate], params[:maxPostedDate])
    render json: @products
  end

  def create
    @product = Product.new(product_params)
    if @product.save
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
