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
end
