require 'rails_helper'

RSpec.describe 'Admin Application Show' do
  describe 'Approving/Rejecting Pet for adoption' do
    it 'has a working approve adoption button' do
      shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      pet_1 = Pet.create(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: shelter.id)
      pet_2 = Pet.create(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter.id)
      zach = Application.create(name: 'Zach Hazelwood', address: '1234 Fake Street', city: 'Faketown', state: 'CO',
                                zip: 12_345, reason: 'I like dogs')
      ApplicationPet.create!(application_id: zach.id, pet_id: pet_1.id)
      ApplicationPet.create!(application_id: zach.id, pet_id: pet_2.id)

      zach.update(status: 'Pending')

      visit "/admin/applications/#{zach.id}"

      within "#pet-#{pet_1.id}" do
        expect(page).to have_link(pet_1.name)
        expect(page).to have_button('Approve')
      end

      within "#pet-#{pet_2.id}" do
        expect(page).to have_link(pet_2.name)
        expect(page).to have_button('Approve')
        click_on 'Approve'
      end

      expect(current_path).to eq("/admin/applications/#{zach.id}")

      within "#pet-#{pet_2.id}" do
        expect(page).to have_link(pet_2.name)
        expect(page).to_not have_button('Approve')
        expect(page).to have_content('Approved!!')
      end
    end

    it 'has a working reject adoption button' do
      shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      pet_1 = Pet.create(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: shelter.id)
      pet_2 = Pet.create(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter.id)
      zach = Application.create(name: 'Zach Hazelwood', address: '1234 Fake Street', city: 'Faketown', state: 'CO',
                                zip: 12_345, reason: 'I like dogs')
      ApplicationPet.create!(application_id: zach.id, pet_id: pet_1.id)
      ApplicationPet.create!(application_id: zach.id, pet_id: pet_2.id)

      zach.update(status: 'Pending')

      visit "/admin/applications/#{zach.id}"

      within "#pet-#{pet_1.id}" do
        expect(page).to have_link(pet_1.name)
        expect(page).to have_button('Reject')
      end

      within "#pet-#{pet_2.id}" do
        expect(page).to have_link(pet_2.name)
        expect(page).to have_button('Reject')
        click_on 'Reject'
      end

      expect(current_path).to eq("/admin/applications/#{zach.id}")

      within "#pet-#{pet_2.id}" do
        expect(page).to have_link(pet_2.name)
        expect(page).to_not have_button('Reject')
        expect(page).to have_content('Rejected!!')
      end
    end

    it 'Approved/Rejected Pets on one Application do not affect other Applications' do
      shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      pet_1 = Pet.create(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: shelter.id)
      pet_2 = Pet.create(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter.id)
      zach = Application.create(name: 'Zach Hazelwood', address: '1234 Fake Street', city: 'Faketown', state: 'CO',
                                zip: 12_345, reason: 'I like dogs')
      bryce = Application.create(name: 'Bryce Hazelwood', address: '1234 Fake Lane', city: 'Realtown', state: 'VA',
                                 zip: 23_322, reason: 'I like to eat dogs')
      ApplicationPet.create!(application_id: zach.id, pet_id: pet_1.id)
      ApplicationPet.create!(application_id: zach.id, pet_id: pet_2.id)
      ApplicationPet.create!(application_id: bryce.id, pet_id: pet_1.id)
      ApplicationPet.create!(application_id: bryce.id, pet_id: pet_2.id)

      zach.update(status: 'Pending')
      bryce.update(status: 'Pending')

      visit "/admin/applications/#{zach.id}"

      within "#pet-#{pet_1.id}" do
        expect(page).to have_link(pet_1.name)
        expect(page).to have_button('Reject')
      end

      within "#pet-#{pet_2.id}" do
        expect(page).to have_link(pet_2.name)
        expect(page).to have_button('Reject')
        click_on 'Reject'
      end

      expect(current_path).to eq("/admin/applications/#{zach.id}")

      within "#pet-#{pet_2.id}" do
        expect(page).to have_link(pet_2.name)
        expect(page).to_not have_button('Reject')
        expect(page).to have_content('Rejected!!')
      end

      visit "/admin/applications/#{bryce.id}"

      within "#pet-#{pet_2.id}" do
        expect(page).to have_link(pet_2.name)
        expect(page).to have_button('Reject')
        expect(page).to have_button('Approve')
      end
    end
  end

  describe 'Completed Applications' do
    it 'Changes application status to approved when all pets accepted on application' do
      shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      pet_1 = Pet.create(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: shelter.id)
      pet_2 = Pet.create(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter.id)
      zach = Application.create(name: 'Zach Hazelwood', address: '1234 Fake Street', city: 'Faketown', state: 'CO',
                                zip: 12_345, reason: 'I like dogs')
      ApplicationPet.create!(application_id: zach.id, pet_id: pet_1.id)
      ApplicationPet.create!(application_id: zach.id, pet_id: pet_2.id)

      zach.update(status: 'Pending')

      visit "/admin/applications/#{zach.id}"

      within "#pet-#{pet_1.id}" do
        click_on 'Approve'
      end

      within "#pet-#{pet_2.id}" do
        click_on 'Approve'
      end

      expect(page).to have_content('Application Status: Approved')
    end

    it 'Changes application status to rejected when atleast one pets adoptions is rejected' do
      shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      pet_1 = Pet.create(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: shelter.id)
      pet_2 = Pet.create(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter.id)
      zach = Application.create(name: 'Zach Hazelwood', address: '1234 Fake Street', city: 'Faketown', state: 'CO',
                                zip: 12_345, reason: 'I like dogs')
      ApplicationPet.create!(application_id: zach.id, pet_id: pet_1.id)
      ApplicationPet.create!(application_id: zach.id, pet_id: pet_2.id)

      zach.update(status: 'Pending')

      visit "/admin/applications/#{zach.id}"

      within "#pet-#{pet_1.id}" do
        click_on 'Approve'
      end

      within "#pet-#{pet_2.id}" do
        click_on 'Reject'
      end

      expect(page).to have_content('Application Status: Rejected')
    end

    it 'Application Approval makes Pets not adoptable' do
      shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      pet_1 = Pet.create(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: shelter.id)
      pet_2 = Pet.create(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter.id)
      zach = Application.create(name: 'Zach Hazelwood', address: '1234 Fake Street', city: 'Faketown', state: 'CO',
                                zip: 12_345, reason: 'I like dogs')
      ApplicationPet.create!(application_id: zach.id, pet_id: pet_1.id)
      ApplicationPet.create!(application_id: zach.id, pet_id: pet_2.id)

      zach.update(status: 'Pending')

      visit "/admin/applications/#{zach.id}"

      within "#pet-#{pet_1.id}" do
        click_on 'Approve'
      end

      within "#pet-#{pet_2.id}" do
        click_on 'Approve'
      end

      visit "/pets/#{pet_1.id}"

      expect(page).to have_content('false')
    end

    it 'if approved on an approved application, no longer are up for approval on another application' do
      shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      pet_1 = Pet.create(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: shelter.id)
      pet_2 = Pet.create(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter.id)
      zach = Application.create(name: 'Zach Hazelwood', address: '1234 Fake Street', city: 'Faketown', state: 'CO',
                                zip: 12_345, reason: 'I like dogs')
      bryce = Application.create(name: 'Bryce Hazelwood', address: '1234 Fake Lane', city: 'Realtown', state: 'VA',
                                 zip: 23_322, reason: 'I like to eat dogs')
      ApplicationPet.create!(application_id: zach.id, pet_id: pet_1.id)
      ApplicationPet.create!(application_id: zach.id, pet_id: pet_2.id)
      ApplicationPet.create!(application_id: bryce.id, pet_id: pet_1.id)
      ApplicationPet.create!(application_id: bryce.id, pet_id: pet_2.id)

      zach.update(status: 'Pending')
      bryce.update(status: 'Pending')

      visit "/admin/applications/#{zach.id}"

      within "#pet-#{pet_1.id}" do
        click_on 'Approve'
      end

      within "#pet-#{pet_2.id}" do
        click_on 'Approve'
      end

      visit "/admin/applications/#{bryce.id}"

      within "#pet-#{pet_1.id}" do
        expect(page).to have_link(pet_1.name)
        expect(page).to have_button('Reject')
        expect(page).to_not have_button('Approve')
        expect(page).to have_content('This pet has been approved for adoption, sorry!')
      end

      within "#pet-#{pet_2.id}" do
        expect(page).to have_link(pet_2.name)
        expect(page).to have_button('Reject')
        expect(page).to_not have_button('Approve')
        expect(page).to have_content('This pet has been approved for adoption, sorry!')
      end
    end
  end
end
