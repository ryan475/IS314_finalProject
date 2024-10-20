class Variant < ApplicationRecord
  belongs_to :product
  has_many :sales

  validates :color, presence: true, uniqueness: { scope: [:size, :product_id], message: "and size combination should be unique per product." }
  validates :size, presence: true
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate :ensure_unique_color_size_combination
  def total_sold
    sales.sum(:quantity)
  end

  def ensure_unique_color_size_combination
    if Variant.where(product_id: product_id, color: color, size: size).exists?
      errors.add(:base, "Variant with the same color and size already exists for this product.")
    end
  end
  scope :out_of_stock, -> { where(quantity: 0) }
  scope :in_stock, -> { where('quantity > ?', 0) }
end
