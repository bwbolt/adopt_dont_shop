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

      visit '/admin/sheters'

      expect(page).to have_content(aurora.name)
      expect(dfl.name).to appear_before(aurora.name)
    end
  end
end
