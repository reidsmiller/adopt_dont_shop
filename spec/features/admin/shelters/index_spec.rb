require 'rails_helper'

RSpec.describe '/admin/shelters', type: :feature do
  describe 'As a visitor, when I visit the admin shelter index' do
    before(:each) do
      @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
      @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)
      @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
      @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
      @pet_3 = @shelter_3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
      @pet_4 = @shelter_2.pets.create(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster')
    end

    it '#SQL ONLY I see all the shelters in the system listed in reverse alphabetical order by name' do
      visit '/admin/shelters'

      expect(@shelter_2.name).to appear_before(@shelter_3.name)
      expect(@shelter_2.name).to appear_before(@shelter_1.name)
      expect(@shelter_3.name).to appear_before(@shelter_1.name)
    end
  end
end