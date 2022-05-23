require 'rails_helper'

RSpec.describe "admin_shelters#show" do
  describe "admin_shelters#show find_by_sql" do
    # Admin Shelters Show Page
    #
    # As a visitor
    # When I visit an admin shelter show page
    # Then I see that shelter's name and full address
    it "shows Shelter info to admin" do
      shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)

      visit "admin/shelters/#{shelter.id}"

      expect(page).to have_content(shelter.name)
      expect(page).to have_content(shelter.city)
    end
  end

  describe "User Story 5" do
    # As a visitor
    # When I visit an admin shelter show page
    # Then I see a section for statistics
    # And in that section I see the average age of all adoptable pets for that shelter
    it "has an average Pet:age statistic" do
      shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      pet_1 = Pet.create(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: shelter.id)
      pet_2 = Pet.create(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter.id)
      pet_3 = Pet.create(adoptable: true, age: 2, breed: 'saint bernard', name: 'Beethoven', shelter_id: shelter.id)
      visit "admin/shelters/#{shelter.id}"

      within('#statistics') do
        expect(page).to have_content("Statistics:")
        expect(page).to have_content("Average Age of Adoptable Pets: 2")
      end
    end
  end

  describe "User Story 4" do
    # As a visitor
    # When I visit an admin shelter show page
    # Then I see a section for statistics
    # And in that section I see the number of pets at that shelter that are adoptable
    it "has a count of adoptable pets" do
      shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      pet_1 = Pet.create(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: shelter.id)
      pet_2 = Pet.create(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter.id)
      pet_3 = Pet.create(adoptable: true, age: 2, breed: 'saint bernard', name: 'Beethoven', shelter_id: shelter.id)
      visit "admin/shelters/#{shelter.id}"

      within('#statistics') do
        expect(page).to have_content("Statistics:")
        expect(page).to have_content("Number of Adoptable Pets: 3")
      end
    end
  end
end
