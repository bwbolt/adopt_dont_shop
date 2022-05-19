require 'rails_helper'

RSpec.describe 'Application Show Page' do
  it 'Displays the applications information' do
    shelter = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    pet1 = shelter.pets.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald')
    application = Application.create(name: 'Zach Hazelwood', address: '1234 Fake Street', city: 'Faketown', state: 'CO',
                                     zip: 12_345, reason: 'I like dogs')
    ApplicationPet.create!(application_id: application.id, pet_id: pet1.id)
    visit "/applications/#{application.id}"
    expect(page).to have_content('Zach Hazelwood')
    expect(page).to have_content('1234 Fake Street')
    expect(page).to have_content('Faketown')
    expect(page).to have_content('CO')
    expect(page).to have_content('12345')
    expect(page).to have_content('I like dogs')
    expect(page).to have_content('In Progress')
    save_and_open_page
    # expect(page).to have_link('Lucille Bald')
    # click_link 'Lucille Bald'
    # expect(current_path).to eq("/pets/#{pet1.id}")
  end
end
