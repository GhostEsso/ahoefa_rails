class Property < ApplicationRecord
  belongs_to :user
  has_many_attached :photos

  validates :title, :description, :price, :address, :city, :property_type, :transaction_type, presence: true
  validates :transaction_type, inclusion: { in: %w[sale rent] }
  validates :property_type, inclusion: { in: %w[house apartment land office] }
  validates :surface, presence: true, numericality: { greater_than: 0 }
  validate :photos_count_within_limit

  # Validations conditionnelles pour toutes les propriétés sauf les terrains
  validates :bedrooms, presence: true, numericality: { greater_than_or_equal_to: 0 }, unless: :land?
  validates :bathrooms, presence: true, numericality: { greater_than_or_equal_to: 0 }, unless: :land?

  RESIDENTIAL_TYPES = %w[house apartment]

  def residential?
    RESIDENTIAL_TYPES.include?(property_type)
  end

  def land?
    property_type == "land"
  end

  private

  def photos_count_within_limit
    return unless photos.attached?

    photos_limit = case user.plan
    when "basic" then 2
    when "standard" then 5
    when "premium" then 15
    else 0
    end

    if photos.count > photos_limit
      errors.add(:photos, "ne peut pas dépasser #{photos_limit} photos pour votre plan")
    end
  end
end
