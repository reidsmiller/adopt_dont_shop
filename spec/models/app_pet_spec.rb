require 'rails_helper'

RSpec.describe AppPet, type: :model do
  describe 'relationships' do
    it {should belong_to :app}
    it {should belong_to :pet}
  end

  describe 'instance methods' do
    before(:each) do
      @shelter_1 = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      @shelter_2 = Shelter.create!(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
      @shelter_3 = Shelter.create!(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)
      @pet_1 = @shelter_1.pets.create!(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
      @pet_2 = @shelter_1.pets.create!(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
      @pet_3 = @shelter_3.pets.create!(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
      @pet_4 = @shelter_2.pets.create!(name: 'Lobster', breed: 'doberman', age: 3, adoptable: false)
      @app_1 = App.create!(name: 'John Travolta', street_address: '1234 Albany Lane', city: 'Boulder', state: 'CO', zip_code: '80534', description: 'I like dogs, you have dogs, give me a dog.', status: "Pending")
      @app_2 = App.create!(name: 'Biggie Smalls', street_address: '2341 Huba Drive', city: 'Detroit', state: 'MI', zip_code: '76543', description: 'Im a dog person. Always wanted a dog. Holla.')
      @app_pet_1 = AppPet.create!(pet_id: @pet_1.id, app_id: @app_1.id)
      @app_pet_2 = AppPet.create!(pet_id: @pet_2.id, app_id: @app_1.id)
      @app_pet_3 = AppPet.create!(pet_id: @pet_3.id, app_id: @app_2.id)
      @app_pet_4 = AppPet.create!(pet_id: @pet_4.id, app_id: @app_2.id)
    end

    it 'can change status based on parameter' do
      params_1 = {commit: "Approve", pet_id: @app_pet_1.pet_id, id: @app_pet_1.app_id}
      params_2 = {commit: "Reject", pet_id: @app_pet_2.pet_id, id: @app_pet_2.app_id}
      AppPet.change_status(params_1)
      updated_app_pet_1 = AppPet.find(@app_pet_1.id)
      AppPet.change_status(params_2)
      updated_app_pet_2 = AppPet.find(@app_pet_2.id)
      expect(updated_app_pet_1.status).to eq('Approved')
      expect(updated_app_pet_2.status).to eq('Rejected')
    end

    it 'can check app_pet status and pet adoptable status and send a status code' do
      @app_pet_1.update(status: "Pending")
      @app_pet_2.update(status: "Approved")
      @app_pet_3.update(status: "Rejected")
      @app_pet_4.update(status: "Pending")
      expect(AppPet.match_pet_to_app_pet(@pet_1.id)).to eq("Pending")
      expect(AppPet.match_pet_to_app_pet(@pet_2.id)).to eq("Approved")
      expect(AppPet.match_pet_to_app_pet(@pet_3.id)).to eq("Rejected")
      expect(AppPet.match_pet_to_app_pet(@pet_4.id)).to eq("Adopted")
    end
  end
end