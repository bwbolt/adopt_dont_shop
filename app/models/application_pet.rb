class ApplicationPet < ApplicationRecord
  belongs_to :pet
  belongs_to :application

  def self.search(pet_id, application_id)
    where(pet_id: pet_id, application_id: application_id).first
  end
end
