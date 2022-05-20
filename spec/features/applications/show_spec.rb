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
    expect(page).to have_link('Lucille Bald')
    click_link 'Lucille Bald'
    expect(current_path).to eq("/pets/#{pet1.id}")
  end
  it 'Displays a working "Add a Pet to this Application" input if the application has not been submitted' do
    shelter = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    pet1 = shelter.pets.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald')
    application = Application.create(name: 'Zach Hazelwood', address: '1234 Fake Street', city: 'Faketown', state: 'CO',
                                     zip: 12_345, reason: 'I like dogs')
    ApplicationPet.create!(application_id: application.id, pet_id: pet1.id)
    visit "/applications/#{application.id}"
    expect(page).to have_content('Add a pet to this application')
    fill_in 'pets_by_name', with: 'Lucille Bald'
    click_on 'submit'
    expect(current_path).to eq("/applications/#{application.id}")
    expect(page).to have_content(pet1.name)
  end

  it 'Displays a working "Adopt this Pet" button next to searched pet' do
    shelter = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    pet1 = shelter.pets.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald')
    application = Application.create(name: 'Zach Hazelwood', address: '1234 Fake Street', city: 'Faketown', state: 'CO',
                                     zip: 12_345, reason: 'I like dogs')
    ApplicationPet.create!(application_id: application.id, pet_id: pet1.id)
    visit "/applications/#{application.id}"
    fill_in 'pets_by_name', with: 'Lucille Bald'
    click_on 'submit'
    expect(page).to have_content(pet1.name)
    expect(page).to have_button("Adopt #{pet1.name}")
    click_button("Adopt #{pet1.name}")
    expect(current_path).to eq("/applications/#{application.id}")
    within('#applicant_info') do
      expect(page).to have_content(pet1.name)
    end
  end
end
