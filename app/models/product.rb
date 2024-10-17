class Product < ApplicationRecord
  has_many :variants, dependent: :destroy
  has_many :sales, through: :variants
  has_one_attached :image
  has_many :product_colors
  has_many :colors, through: :product_colors

  accepts_nested_attributes_for :variants, allow_destroy: true

  # Validations
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :description, presence: true
  validates :image, presence: true # Optional, if image is mandatory

  # Custom validation for variants
  validate :must_have_at_least_one_variant

  GENDERS = ['Men', 'Women'] # You can adjust these options

  validates :gender, inclusion: { in: GENDERS }

  # Scopes for sales
  def self.most_sold
    joins(variants: :sales)
      .group('products.id')
      .order('SUM(sales.quantity) DESC')
      .first
  end

  def self.least_sold
    joins(variants: :sales)
      .group('products.id')
      .order('SUM(sales.quantity) ASC')
      .first
  end

  def self.search(query)
    where("name LIKE ? OR description LIKE ?", "%#{query}%", "%#{query}%")
  end
  
  params.require(:product).permit(:name, :description, :price, :image, :gender, variants_attributes: [:id, :color, :size, :quantity, :_destroy])

  private
  
  # Ensure at least one variant exists
  def must_have_at_least_one_variant
    if variants.reject(&:marked_for_destruction?).empty?
      errors.add(:variants, "must have at least one variant")
    end
  end
end
