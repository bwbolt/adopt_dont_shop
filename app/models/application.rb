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

  before_validation :normalize_info, on: :create

  private

  def normalize_info
    unless name.nil? || city.nil?
      self.name = name.downcase.titleize
      self.city = city.downcase.titleize
    end
  end
end
