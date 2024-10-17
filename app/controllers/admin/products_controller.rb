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
    @product.destroy

    respond_to do |format|
      format.html { redirect_to admin_products_path, notice: 'Product was successfully deleted.' }
      format.js   # Handles JavaScript response if using Ajax
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
  end

  def filter_products
    # Ensure prices are within valid ranges
    if params[:min_price].present? && params[:min_price].to_f < 0
      flash[:alert] = "Minimum price cannot be less than 0."
      params[:min_price] = nil
    end

    if params[:max_price].present? && params[:max_price].to_f > 100
      flash[:alert] = "Maximum price cannot exceed 100."
      params[:max_price] = nil
    end

    if params[:min_price].present? && params[:max_price].present?
      if params[:min_price].to_f > params[:max_price].to_f
        flash[:alert] = "Minimum price cannot be greater than maximum price."
        params[:min_price] = nil
        params[:max_price] = nil
      end
    end

    # Apply filters independently
    @products = @products.search(params[:query]) if params[:query].present?
    @products = @products.joins(:category).where(categories: { id: params[:category] }) if params[:category].present?

    if params[:color].present?
      @products = @products.joins(:variants).where(variants: { color: params[:color] }).distinct
    end

    if params[:size].present?
      @products = @products.joins(:variants).where(variants: { size: params[:size] }).distinct
    end

    @products = @products.where('price >= ?', params[:min_price]) if params[:min_price].present?
    @products = @products.where('price <= ?', params[:max_price]) if params[:max_price].present?
  end

  def set_filters
    @categories = Category.all
    @colors = ['Black', 'Blue', 'Red', 'White', 'Grey', 'Green', 'Yellow', 'Maroon', 'Pink']
    @sizes = ['XS', 'S', 'M', 'L', 'XL', '2XL', '3XL']
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :image, variants_attributes: [:id, :color, :size, :quantity, :_destroy])
  end

  def load_colors_from_xml
    file = File.read(Rails.root.join('config', 'colors.xml'))
    doc = Nokogiri::XML(file)

    colors = []
    doc.xpath('//color').each do |color_node|
      colors << { name: color_node.attr('name'), hex: color_node.attr('hex') }
    end

    colors
  end
end
