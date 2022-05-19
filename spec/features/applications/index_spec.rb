require 'rails_helper'

RSpec.describe "Applications#index", type: :feature do
  describe "index" do
    it "displays all submitted applications" do
      shelter = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      pet1 = shelter.pets.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald')
      application = Application.create(name: 'Zach Hazelwood', address: '1234 Fake Street', city: 'Faketown', state: 'CO',
                                       zip: 12_345, reason: 'I like dogs')
      ApplicationPet.create!(application_id: application.id, pet_id: pet1.id)

      visit "/applications"

      expect(page).to have_content("Zach Hazelwood")
      expect(page).to have_link("New Application")
    end
  end
end
