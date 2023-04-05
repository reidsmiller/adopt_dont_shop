require 'rails_helper'

RSpec.describe 'admin shelter show page' do
  describe 'as a visitor, when I visit an admin shelter show page' do
    before(:each) do
      @shelter_1 = Shelter.create!(name: 'Boulder Humane Society', city: 'Boulder', rank: 3)
      @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false)
      @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
      @pet_4 = @shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true)
    end

    it "I can see the shelter's name and full address" do
      visit "/admin/shelters/#{@shelter_1.id}"

      expect(page).to have_content(@shelter_1.name)
      expect(page).to have_content(@shelter_1.city)
      expect(page).to have_content(@shelter_1.rank)
    end

    it 'I see a section for stats containing avg age of all adoptable pets for specific shelter' do
      visit "/admin/shelters/#{@shelter_1.id}"
    
      
      expect(page).to have_content("Pet Statistics")
      expect(page).to have_content("Average age of all adoptable pets: 4.0 years")
    
    end
  end
end