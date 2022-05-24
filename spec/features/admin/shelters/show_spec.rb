require 'rails_helper'

RSpec.describe 'admin_shelters#show' do
  describe 'admin_shelters#show find_by_sql' do
    it 'shows Shelter info to admin' do
      shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)

      visit "admin/shelters/#{shelter.id}"

      expect(page).to have_content(shelter.name)
      expect(page).to have_content(shelter.city)
    end
  end

  describe 'User Story 5' do
    it 'has an average Pet:age statistic' do
      shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      pet_1 = Pet.create(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: shelter.id)
      pet_2 = Pet.create(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter.id)
      pet_3 = Pet.create(adoptable: true, age: 2, breed: 'saint bernard', name: 'Beethoven', shelter_id: shelter.id)

      visit "admin/shelters/#{shelter.id}"

      within('#statistics') do
        expect(page).to have_content('Statistics:')
        expect(page).to have_content('Average Age of Adoptable Pets: 2')
      end
    end
  end

  describe 'User Story 4' do
    it 'has a count of adoptable pets' do
      shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      pet_1 = Pet.create(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: shelter.id)
      pet_2 = Pet.create(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter.id)
      pet_3 = Pet.create(adoptable: true, age: 2, breed: 'saint bernard', name: 'Beethoven', shelter_id: shelter.id)

      visit "admin/shelters/#{shelter.id}"

      within('#statistics') do
        expect(page).to have_content('Statistics:')
        expect(page).to have_content('Number of Adoptable Pets: 3')
      end
    end
  end

  describe 'User Story 3' do
    it 'has a count of adopted pets' do
      shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      pet_1 = Pet.create(adoptable: false, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: shelter.id)
      pet_2 = Pet.create(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter.id)
      pet_3 = Pet.create(adoptable: true, age: 2, breed: 'saint bernard', name: 'Beethoven', shelter_id: shelter.id)

      visit "admin/shelters/#{shelter.id}"

      within('#statistics') do
        expect(page).to have_content('Statistics:')
        expect(page).to have_content('Number of Adopted Pets: 1')
      end
    end
  end

  describe 'User Story 2' do
    it "has an 'Action Required' section for pets on a 'Pending' application" do
      shelter = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      pet_1 = shelter.pets.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald')
      pet_2 = Pet.create(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter.id)
      pet_3 = Pet.create(adoptable: true, age: 2, breed: 'saint bernard', name: 'Beethoven', shelter_id: shelter.id)
      pet_4 = Pet.create(adoptable: true, age: 2, breed: 'saint bernard', name: 'Big Dog', shelter_id: shelter.id)
      application = Application.create(name: 'Zach Hazelwood', address: '1234 Fake Street', city: 'Faketown', state: 'CO',
                                       zip: 12_345, reason: 'I like dogs')
      ApplicationPet.create!(application_id: application.id, pet_id: pet_1.id)
      ApplicationPet.create!(application_id: application.id, pet_id: pet_2.id)
      ApplicationPet.create!(application_id: application.id, pet_id: pet_3.id)

      application.update(status: 'Pending')

      visit "/admin/shelters/#{shelter.id}"

      within('#action_required') do
        expect(page).to have_content('Action Required')
        expect(page).to have_content(pet_1.name)
        expect(page).to have_content(pet_2.name)
        expect(page).to have_content(pet_3.name)
        expect(page).to_not have_content(pet_4.name)
      end

      application.update(status: 'Approved')

      visit "/admin/shelters/#{shelter.id}"

      within('#action_required') do
        expect(page).to have_content('Action Required')
        expect(page).to_not have_content(pet_1.name)
        expect(page).to_not have_content(pet_2.name)
        expect(page).to_not have_content(pet_3.name)
      end
    end
  end

  describe 'User Story 1' do
    it "has an 'Action Required' section with link to application#show for each" do
      shelter = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      pet_1 = shelter.pets.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald')
      pet_2 = Pet.create(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter.id)
      pet_3 = Pet.create(adoptable: true, age: 2, breed: 'saint bernard', name: 'Beethoven', shelter_id: shelter.id)
      pet_4 = Pet.create(adoptable: true, age: 2, breed: 'saint bernard', name: 'Big Dog', shelter_id: shelter.id)
      application = Application.create(name: 'Zach Hazelwood', address: '1234 Fake Street', city: 'Faketown', state: 'CO',
                                       zip: 12_345, reason: 'I like dogs')
      ApplicationPet.create!(application_id: application.id, pet_id: pet_1.id)
      ApplicationPet.create!(application_id: application.id, pet_id: pet_2.id)
      ApplicationPet.create!(application_id: application.id, pet_id: pet_3.id)

      application.update(status: 'Pending')

      visit "/admin/shelters/#{shelter.id}"

      within('#action_required') do
        expect(page).to have_content('Action Required')
        expect(page).to have_content(pet_1.name)
        expect(page).to have_link("#{pet_1.name} Application")
        expect(page).to have_content(pet_2.name)
        expect(page).to have_link("#{pet_2.name} Application")
        expect(page).to have_content(pet_3.name)
        expect(page).to have_link("#{pet_3.name} Application")
        expect(page).to_not have_content(pet_4.name)

        click_link("#{pet_1.name} Application")

        expect(current_path).to eq("/admin/applications/#{application.id}")
      end

      application.update(status: 'Approved')

      visit "/admin/shelters/#{shelter.id}"

      within('#action_required') do
        expect(page).to have_content('Action Required')
        expect(page).to_not have_content(pet_1.name)
        expect(page).to_not have_link("#{pet_1.name} Application")
      end
    end
  end
end
