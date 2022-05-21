class Application < ApplicationRecord
  validates :name, presence: true
  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :reason, presence: true
  validates :zip, presence: true, numericality: true

  has_many :application_pets
  has_many :pets, through: :application_pets
  has_many :shelters, through: :pets
end
