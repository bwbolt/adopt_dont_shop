require 'rails_helper'

RSpec.describe Application, type: :model do
  describe 'relationships' do
    it { should have_many(:application_pets) }
    it { should have_many(:pets).through(:application_pets) }
    it { should have_many(:shelters).through(:pets) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:address) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:reason) }
    it { should validate_numericality_of(:zip) }

    it 'Normalized name and city' do
      zach = Application.create(name: 'zaCh hazELwood', address: '1234 Fake Street', city: 'fakeTown', state: 'CO',
                                zip: 12_345, reason: 'I like dogs')
      zach.valid?
      expect(zach.name).to eq('Zach Hazelwood')
      expect(zach.city).to eq('Faketown')
    end
  end
end
