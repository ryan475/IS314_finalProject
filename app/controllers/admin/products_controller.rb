class Admin::ProductsController < Admin::BaseController
  require 'nokogiri'
  before_action :set_filters, only: [:index, :new, :edit]
  before_action :set_product, only: [:show, :edit, :update, :destroy, :remove_image]

  def index
    @products = Product.all
    filter_products
  end

  def show
    unless @product
      flash[:alert] = "Product not found."
      redirect_to admin_products_path and return
    end
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
  
    if @product.save
      redirect_to admin_products_path, notice: "Product successfully created!"
    else
      render :new
    end
  end
  
  def edit
    unless @product
      flash[:alert] = "Product not found."
      redirect_to admin_products_path and return
    end
  end

  def update
    if @product.update(product_params)
      redirect_to admin_products_path, notice: 'Product was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @product.destroy
      redirect_to admin_products_path, notice: 'Product was successfully deleted.'
    else
      redirect_to admin_products_path, alert: 'Failed to delete the product.'
    end
  end
  
  def remove_image
    if @product.image.attached?
      @product.image.purge
      redirect_to edit_admin_product_path(@product), notice: 'Image was successfully removed.'
    else
      redirect_to edit_admin_product_path(@product), alert: 'No image to remove.'
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :price, :image, :gender, variants_attributes: [:id, :color, :size, :quantity, :_destroy])
  end
  
  def set_product
    @product = Product.find_by(id: params[:id])
    @products = Product.includes(:variants, :category).all

  end
  def filter_products
    check_price_ranges
  
    @products = @products.search(params[:query]) if params[:query].present?
    @products = filter_by_category(@products)
    @products = filter_by_color(@products)
    @products = filter_by_size(@products)
    @products = filter_by_price_range(@products)
  end
  
  def check_price_ranges
    if params[:min_price].to_f < 0
      flash[:alert] = "Minimum price cannot be less than 0."
      params[:min_price] = nil
    end
  
    if params[:max_price].to_f > 100
      flash[:alert] = "Maximum price cannot exceed 100."
      params[:max_price] = nil
    end
  
    if params[:min_price].to_f > params[:max_price].to_f
      flash[:alert] = "Minimum price cannot be greater than maximum price."
      params[:min_price] = nil
      params[:max_price] = nil
    end
  end
  
  def filter_by_category(products)
    return products unless params[:category].present?
    products.joins(:category).where(categories: { id: params[:category] })
  end
  
  def filter_by_color(products)
    return products unless params[:color].present?
    products.joins(:variants).where(variants: { color: params[:color] }).distinct
  end
  
  def filter_by_size(products)
    return products unless params[:size].present?
    products.joins(:variants).where(variants: { size: params[:size] }).distinct
  end
  
  def filter_by_price_range(products)
    products = products.where('price >= ?', params[:min_price]) if params[:min_price].present?
    products = products.where('price <= ?', params[:max_price]) if params[:max_price].present?
    products
  end  
end
