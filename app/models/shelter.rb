class Shelter < ApplicationRecord
  validates :name, presence: true
  validates :rank, presence: true, numericality: true
  validates :city, presence: true

  has_many :pets, dependent: :destroy
  has_many :applications, through: :pets

  def self.order_by_recently_created
    order(created_at: :desc)
  end

  def self.order_by_number_of_pets
    select('shelters.*, count(pets.id) AS pets_count')
      .joins('LEFT OUTER JOIN pets ON pets.shelter_id = shelters.id')
      .group('shelters.id')
      .order('pets_count DESC')
  end

  def self.has_pending_application
    joins(pets: :applications).where(applications: { status: 'Pending' }).order(:name).distinct
  end

  def pet_count
    pets.count
  end

  def adoptable_pets
    pets.where(adoptable: true)
  end

  def adopted_pets
    pets.where(adoptable: false)
  end

  def adoptable_pets_count
    adoptable_pets.count
  end

  def adopted_pets_count
    adopted_pets.count
  end

  def alphabetical_pets
    adoptable_pets.order(name: :asc)
  end

  def shelter_pets_filtered_by_age(age_filter)
    adoptable_pets.where('age >= ?', age_filter)
  end

  def average_age
    adoptable_pets.average(:age)
  end
end
