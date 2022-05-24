require 'rails_helper'

RSpec.describe 'Admin Shelter Index' do
  describe 'User Story 17' do
    it 'displays shelter information to an admin in reverse alphabetical order' do
      foothills = Shelter.create(name: 'Foothills Animal Shelter', city: 'Golden, CO', foster_program: true, rank: 3)
      aurora = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      dfl = Shelter.create(name: 'Dumb Friends League', city: 'Denver, CO', foster_program: true, rank: 2)

      visit '/admin/shelters'

      expect(page).to have_content(aurora.name)
      expect(dfl.name).to appear_before(aurora.name)
    end
  end

  describe 'User Story 16' do
    it 'displays shelters with pending applications' do
      foothills = Shelter.create(name: 'Foothills Animal Shelter', city: 'Golden, CO', foster_program: true, rank: 3)
      aurora = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      dfl = Shelter.create(name: 'Dumb Friends League', city: 'Denver, CO', foster_program: true, rank: 2)

      pet1 = aurora.pets.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald')
      application = Application.create(name: 'Zach Hazelwood', address: '1234 Fake Street', city: 'Faketown', state: 'CO',
                                       zip: 12_345, reason: 'I like dogs')
      ApplicationPet.create!(application_id: application.id, pet_id: pet1.id)

      application.update(status: 'Pending')

      visit '/admin/shelters'

      within '#pending_applications' do
        expect(page).to have_content(aurora.name)
        expect(page).to_not have_content(dfl.name)
      end
    end
  end

  describe 'User Story 7' do
    it 'shows shelters with pending applications, listed alphabetically' do
      foothills = Shelter.create(name: 'Foothills Animal Shelter', city: 'Golden, CO', foster_program: true, rank: 3)
      aurora = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      dfl = Shelter.create(name: 'Dumb Friends League', city: 'Denver, CO', foster_program: true, rank: 2)

      pet1 = foothills.pets.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald')
      application = Application.create(name: 'Zach Hazelwood', address: '1234 Fake Street', city: 'Faketown', state: 'CO',
                                       zip: 12_345, reason: 'I like dogs')
      ApplicationPet.create!(application_id: application.id, pet_id: pet1.id)

      pet2 = aurora.pets.create!(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster')
      application_2 = Application.create(name: 'Bryce Wein', address: '222 Real Road', city: 'Faketown', state: 'CO',
                                         zip: 12_222, reason: 'Dog good')
      ApplicationPet.create!(application_id: application_2.id, pet_id: pet2.id)

      application.update(status: 'Pending')
      application_2.update(status: 'Pending')

      visit '/admin/shelters'

      within '#pending_applications' do
        expect(aurora.name).to appear_before(foothills.name)
      end
    end
  end

  describe 'User Story 6' do
    it 'shows links as Shelter names' do
      foothills = Shelter.create(name: 'Foothills Animal Shelter', city: 'Golden, CO', foster_program: true, rank: 3)
      aurora = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      dfl = Shelter.create(name: 'Dumb Friends League', city: 'Denver, CO', foster_program: true, rank: 2)

      pet1 = foothills.pets.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald')
      application = Application.create(name: 'Zach Hazelwood', address: '1234 Fake Street', city: 'Faketown', state: 'CO',
                                       zip: 12_345, reason: 'I like dogs')
      ApplicationPet.create!(application_id: application.id, pet_id: pet1.id)

      pet2 = aurora.pets.create!(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster')
      application_2 = Application.create(name: 'Bryce Wein', address: '222 Real Road', city: 'Faketown', state: 'CO',
                                         zip: 12_222, reason: 'Dog good')
      ApplicationPet.create!(application_id: application_2.id, pet_id: pet2.id)

      application.update(status: 'Pending')
      application_2.update(status: 'Pending')

      visit '/admin/shelters'

      expect(page).to have_link(aurora.name)
      expect(page).to have_link(foothills.name)
      expect(page).to have_link(dfl.name)
    end
  end
end
