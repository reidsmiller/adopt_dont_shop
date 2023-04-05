require 'rails_helper'

RSpec.describe '/admin/apps/:id', type: :feature do
  describe 'As a visitor, when I visit an admin application show page' do
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
      AppPet.create!(pet_id: @pet_1.id, app_id: @app_1.id)
      AppPet.create!(pet_id: @pet_2.id, app_id: @app_1.id)
      AppPet.create!(pet_id: @pet_4.id, app_id: @app_2.id)
      AppPet.create!(pet_id: @pet_1.id, app_id: @app_2.id)
    end

    it 'For every pet that the application is for, I see a button to approve the application for that specific pet' do
      visit "/admin/apps/#{@app_1.id}"

      expect(page).to have_content("#{@app_1.name}'s Application for Adoption Approval")
      expect(page).to have_content("Street Address: #{@app_1.street_address}")
      expect(page).to have_content("City: #{@app_1.city}")
      expect(page).to have_content("State: #{@app_1.state}")
      expect(page).to have_content("Zip Code: #{@app_1.zip_code}")
      expect(page).to have_content("Description: #{@app_1.description}")
      expect(page).to have_content("Applied to Adopt:")
      within("li#Admin_#{@pet_1.id}") do
        expect(page).to have_content(@pet_1.name)
        expect(page).to have_button("Approve")
      end
      within("li#Admin_#{@pet_2.id}") do
        expect(page).to have_content(@pet_2.name)
        expect(page).to have_button("Approve")
      end
      expect(page).to have_content("Application Status: #{@app_1.status}")
    end

    it 'When I click an approve to adopt button I return to the admin app show page and instead of the button I see indicator pet has been approved' do
      visit "/admin/apps/#{@app_1.id}"

      within("li#Admin_#{@pet_1.id}") do
        click_button "Approve"
      end
      
      expect(current_path).to eq("/admin/apps/#{@app_1.id}")
      within("li#Admin_#{@pet_1.id}") do
        expect(page).to_not have_button("Approve")
        expect(page).to have_content("Adoption Approved")
      end
      within("li#Admin_#{@pet_2.id}") do
        expect(page).to have_button("Approve")
      end
    end

    it 'For every pet that the application is for, I see a button to reject the application for that specific pet' do
      visit "/admin/apps/#{@app_1.id}"

      expect(page).to have_content("#{@app_1.name}'s Application for Adoption Approval")
      expect(page).to have_content("Street Address: #{@app_1.street_address}")
      expect(page).to have_content("City: #{@app_1.city}")
      expect(page).to have_content("State: #{@app_1.state}")
      expect(page).to have_content("Zip Code: #{@app_1.zip_code}")
      expect(page).to have_content("Description: #{@app_1.description}")
      expect(page).to have_content("Applied to Adopt:")
      within("li#Admin_#{@pet_1.id}") do
        expect(page).to have_content(@pet_1.name)
        expect(page).to have_button("Reject")
      end
      within("li#Admin_#{@pet_2.id}") do
        expect(page).to have_content(@pet_2.name)
        expect(page).to have_button("Reject")
      end
      expect(page).to have_content("Application Status: #{@app_1.status}")
    end

    it 'When I click an approve to adopt button I return to the admin app show page and instead of the button I see indicator pet has been approved' do
      visit "/admin/apps/#{@app_1.id}"

      within("li#Admin_#{@pet_1.id}") do
        click_button "Reject"
      end
      
      expect(current_path).to eq("/admin/apps/#{@app_1.id}")
      within("li#Admin_#{@pet_1.id}") do
        expect(page).to_not have_button("Reject")
        expect(page).to have_content("Adoption Rejected")
      end
      within("li#Admin_#{@pet_2.id}") do
        expect(page).to have_button("Reject")
      end
    end

    it 'When there are two applications for the same pet and one is approved for adoption on one app, it will not change the others' do
      visit "/admin/apps/#{@app_1.id}"
      within("li#Admin_#{@pet_1.id}") do
        click_button "Approve"
      end

      visit "/admin/apps/#{@app_2.id}"
      within("li#Admin_#{@pet_1.id}") do
        expect(page).to have_button("Approve")
        expect(page).to have_button("Reject")
      end
    end

    it 'When there are two applications for the same pet and one is rejected for adoption on one app, it will not change the other app' do
      visit "/admin/apps/#{@app_1.id}"
      within("li#Admin_#{@pet_1.id}") do
        click_button "Reject"
      end

      visit "/admin/apps/#{@app_2.id}"
      within("li#Admin_#{@pet_1.id}") do
        expect(page).to have_button("Approve")
        expect(page).to have_button("Reject")
      end
    end

    it 'and I approve all pets for application I am taken back to show page and see app status is Approved' do
      visit "/admin/apps/#{@app_1.id}"

      expect(page).to have_content('Application Status: Pending')
      expect(page).to_not have_content('Application Status: Approved')

      within("li#Admin_#{@pet_1.id}") do
        click_button "Approve"
      end

      expect(page).to have_content('Application Status: Pending')
      expect(page).to_not have_content('Application Status: Approved')

      within("li#Admin_#{@pet_2.id}") do
        click_button "Approve"
      end

      expect(page).to have_content('Application Status: Approved')
      expect(page).to_not have_content('Application Status: Pending')
    end

    it 'If I reject one or more pets for the application and all others are approved I see the applications status as Rejected' do
      visit "/admin/apps/#{@app_1.id}"

      expect(page).to have_content('Application Status: Pending')
      expect(page).to_not have_content('Application Status: Rejectd')

      within("li#Admin_#{@pet_1.id}") do
        click_button "Reject"
      end

      expect(page).to have_content('Application Status: Pending')
      expect(page).to_not have_content('Application Status: Rejectd')

      within("li#Admin_#{@pet_2.id}") do
        click_button "Approve"
      end

      expect(page).to have_content('Application Status: Rejected')
      expect(page).to_not have_content('Application Status: Pending')
    end

    it 'When I approve all pets on a page and visit the show page for those pets I see they are no longer adoptable' do
      visit "/admin/apps/#{@app_1.id}"
      within("li#Admin_#{@pet_1.id}") do
        click_button "Approve"
      end
      within("li#Admin_#{@pet_2.id}") do
        click_button "Approve"
      end

      visit "/pets/#{@pet_1.id}"
      expect(page).to have_content("Adoptable: false")
    end
  end
end