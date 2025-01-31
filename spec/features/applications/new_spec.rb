require 'rails_helper'

RSpec.describe 'applications#new', type: :feature do
  describe 'Starting and Application' do
    it 'can create a new Applicant' do
      visit '/applications/new'

      fill_in :name, with: 'John Smith'
      fill_in :address, with: '222 Main St'
      fill_in :city, with: 'Littleton'
      fill_in :state, with: 'CO'
      fill_in :zip, with: 80_808
      fill_in :reason, with: "I just think they're neat."

      click_button('Submit Application')

      expect(current_path).to eq("/applications/#{Application.first.id}")
      expect(page).to have_content('John Smith')
      expect(page).to have_content('Your application has been received.')
    end
  end

  describe 'Missing Information Submission Errors' do
    it 'displays a message when an Application form field is left empty' do
      # Missing Name
      visit '/applications/new'

      # fill_in :name, with: "John Smith"
      fill_in :address, with: '222 Main St'
      fill_in :city, with: 'Littleton'
      fill_in :state, with: 'CO'
      fill_in :zip, with: 80_808
      fill_in :reason, with: "I just think they're neat."

      click_button('Submit Application')
      expect(page).to have_content('Please enter your Name')

      # Missing Address
      visit '/applications/new'

      fill_in :name, with: 'John Smith'
      # fill_in :address, with: "222 Main St"
      fill_in :city, with: 'Littleton'
      fill_in :state, with: 'CO'
      fill_in :zip, with: 80_808
      fill_in :reason, with: "I just think they're neat."

      click_button('Submit Application')
      expect(page).to have_content('Please enter your Address')

      # Missing Reason for Adoption
      visit '/applications/new'

      fill_in :name, with: 'John Smith'
      fill_in :address, with: '222 Main St'
      fill_in :city, with: 'Littleton'
      fill_in :state, with: 'CO'
      fill_in :zip, with: 80_808
      # fill_in :reason, with: "I just think they're neat."

      click_button('Submit Application')
      expect(page).to have_content('Why would you like to adopt this pet?')

      # Missing City
      visit '/applications/new'

      fill_in :name, with: 'John Smith'
      fill_in :address, with: '222 Main St'
      # fill_in :city, with: "Littleton"
      fill_in :state, with: 'CO'
      fill_in :zip, with: 80_808
      fill_in :reason, with: "I just think they're neat."

      click_button('Submit Application')
      expect(page).to have_content('Please enter your City')

      # Missing State
      visit '/applications/new'

      fill_in :name, with: 'John Smith'
      fill_in :address, with: '222 Main St'
      fill_in :city, with: 'Littleton'
      # fill_in :state, with: "CO"
      fill_in :zip, with: 80_808
      fill_in :reason, with: "I just think they're neat."

      click_button('Submit Application')
      expect(page).to have_content('Please enter your State')

      # Missing Zip Code
      visit '/applications/new'

      fill_in :name, with: 'John Smith'
      fill_in :address, with: '222 Main St'
      fill_in :city, with: 'Littleton'
      fill_in :state, with: 'CO'
      # fill_in :zip, with: 80808
      fill_in :reason, with: "I just think they're neat."

      click_button('Submit Application')
      expect(page).to have_content('Please enter your Zip Code')
    end
  end
end
