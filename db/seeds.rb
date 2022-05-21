# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
ApplicationPet.destroy_all
Pet.destroy_all
Shelter.destroy_all

shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
dfl = Shelter.create(name: 'Dumb Friends League', city: 'Denver, CO', foster_program: true, rank: 2)
foothills = Shelter.create(name: 'Foothills Animal Shelter', city: 'Golden, CO', foster_program: true, rank: 3)

pet_1 = Pet.create(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: shelter.id)
pet_2 = Pet.create(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter.id)
pet_3 = Pet.create(adoptable: false, age: 2, breed: 'saint bernard', name: 'Beethoven', shelter_id: shelter.id)

zach = Application.create(name: 'Zach Hazelwood', address: '1234 Fake Street', city: 'Faketown', state: 'CO',
                                 zip: 12345, reason: 'I like dogs')
bryce = Application.create(name: 'Bryce Wein', address: '222 Real Road', city: 'Faketown', state: 'CO',
                                 zip: 12222, reason: 'Dog good')

ApplicationPet.create!(application_id: zach.id, pet_id: pet_1.id)
ApplicationPet.create!(application_id: bryce.id, pet_id: pet_2.id)
