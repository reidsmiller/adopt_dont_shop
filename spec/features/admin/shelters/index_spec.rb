require 'rails_helper'

RSpec.describe '/admin/shelters', type: :feature do
  describe 'As a visitor, when I visit the admin shelter index' do
    before(:each) do
      @shelter_1 = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      @shelter_2 = Shelter.create!(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
      @shelter_3 = Shelter.create!(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)
      @pet_1 = @shelter_1.pets.create!(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
      @pet_2 = @shelter_1.pets.create!(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
      @pet_3 = @shelter_3.pets.create!(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
      @pet_4 = @shelter_2.pets.create!(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster')
      @app_1 = App.create!(name: 'John Travolta', street_address: '1234 Albany Lane', city: 'Boulder', state: 'CO', zip_code: '80534', description: 'I like dogs, you have dogs, give me a dog.', status: "Pending")
      @app_2 = App.create!(name: 'Biggie Smalls', street_address: '2341 Huba Drive', city: 'Detroit', state: 'MI', zip_code: '76543', description: 'Im a dog person. Always wanted a dog. Holla.')
      @app_3 = App.create!(name: 'Johnny Luke', street_address: '1234 Spike Rd.', city: 'Spring', state: 'CO', zip_code: '80554', description: 'I like dogs, you have dogs, give me a dog.', status: "Pending")
      AppPet.create!(pet_id: @pet_1.id, app_id: @app_1.id)
      AppPet.create!(pet_id: @pet_4.id, app_id: @app_2.id)
      AppPet.create!(pet_id: @pet_4.id, app_id: @app_3.id)
    end

    it '#SQL ONLY I see all the shelters in the system listed in reverse alphabetical order by name' do
      visit '/admin/shelters'

      expect(@shelter_2.name).to appear_before(@shelter_3.name)
      expect(@shelter_2.name).to appear_before(@shelter_1.name)
      expect(@shelter_3.name).to appear_before(@shelter_1.name)
    end

    it 'I see a section for shelters with pending applications and the neame of every shelter that has a pending application' do
      visit '/admin/shelters'

      expect(page).to have_content('Shelters with Pending Applications')
      within('div#shelters_pending_apps') do
        expect(page).to have_content(@shelter_1.name)
        expect(page).to_not have_content(@shelter_3.name)
      end
    end

    it 'I see shelter name with a link pointed to shelters admin show page' do
      visit '/admin/shelters'

      expect(page).to have_link('Aurora shelter', href: "/admin/shelters/#{@shelter_1.id}")
      
      click_link("Aurora shelter")

      expect(page).to have_current_path("/admin/shelters/#{@shelter_1.id}")

    it 'I see all shelters listed aplhabetically' do
      visit '/admin/shelters'

      aurora = find("#shelter-#{@shelter_1.id}")
      rgv = find("#shelter-#{@shelter_2.id}")

      expect(aurora).to appear_before(rgv)
    end
  end
end