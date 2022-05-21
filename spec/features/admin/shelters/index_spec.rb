require 'rails_helper'

RSpec.describe "Admin Shelter Index" do
  describe "User Story 17" do
    # As a visitor
    # When I visit the admin shelter index ('/admin/shelters')
    # Then I see all Shelters in the system listed in reverse alphabetical order by name

    it "displays shelter information to an admin in reverse alphabetical order" do
      foothills = Shelter.create(name: 'Foothills Animal Shelter', city: 'Golden, CO', foster_program: true, rank: 3)
      aurora = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      dfl = Shelter.create(name: 'Dumb Friends League', city: 'Denver, CO', foster_program: true, rank: 2)

      visit '/admin/shelters'

      expect(page).to have_content(aurora.name)
      expect(dfl.name).to appear_before(aurora.name)
    end
  end

  describe "User Story 16" do
    # As a visitor
    # When I visit the admin shelter index ('/admin/shelters')
    # Then I see a section for "Shelter's with Pending Applications"
    # And in this section I see the name of every shelter that has a pending application

    it "displays shelters with pending applications" do
      foothills = Shelter.create(name: 'Foothills Animal Shelter', city: 'Golden, CO', foster_program: true, rank: 3)
      aurora = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      dfl = Shelter.create(name: 'Dumb Friends League', city: 'Denver, CO', foster_program: true, rank: 2)

      pet1 = aurora.pets.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald')
      application = Application.create(name: 'Zach Hazelwood', address: '1234 Fake Street', city: 'Faketown', state: 'CO',
                                       zip: 12_345, reason: 'I like dogs')
      ApplicationPet.create!(application_id: application.id, pet_id: pet1.id)

      application.update(status: "Pending")
      visit '/admin/shelters'

      within "#pending_applications" do
        expect(page).to have_content(aurora.name)
        expect(page).to_not have_content(dfl.name)
      end
    end
  end
end
