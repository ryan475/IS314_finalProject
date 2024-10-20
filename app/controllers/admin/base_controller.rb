class Admin::BaseController < ApplicationController
  before_action :authenticate_admin_admin!

  private

  # Strong Parameters for Product
  def product_params
    params.require(:product).permit(
      :name, :description, :price, :image, :gender,
      variants_attributes: [:id, :color, :size, :quantity, :_destroy]
    )
  end

  # Show Action for Admin Products
  def show
    @product = Product.find(params[:id])
  end
end
