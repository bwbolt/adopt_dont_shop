require 'rails_helper'

RSpec.describe ApplicationPet, type: :model do
  describe 'relationships' do
    it { should belong_to(:pet) }
    it { should belong_to(:application) }
  end

  describe "class methods" do
    it "#search" do
      shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      pet_1 = Pet.create(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: shelter.id)
      pet_2 = Pet.create(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter.id)
      zach = Application.create(name: 'Zach Hazelwood', address: '1234 Fake Street', city: 'Faketown', state: 'CO',
                                zip: 12_345, reason: 'I like dogs')
      a_pet_1 = ApplicationPet.create!(application_id: zach.id, pet_id: pet_1.id)
      a_pet_2 = ApplicationPet.create!(application_id: zach.id, pet_id: pet_2.id)
      zach.update(status: 'Pending')

      expect(ApplicationPet.search(pet_1.id, zach.id).id).to eq(a_pet_1.id)
    end
  end
end
