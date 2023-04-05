require 'rails_helper'

RSpec.describe App, type: :model do
  describe 'relationships' do
    it {should have_many :app_pets}
    it {should have_many(:pets).through(:app_pets)}
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:street_address) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:zip_code) }
    it { should validate_presence_of(:description) }
  end

  describe 'instance methods' do
    before(:each) do
      @shelter_1 = Shelter.create!(foster_program: true, name: 'Boulder Humane Society', city: 'Boulder', rank: 3)
      @app_1 = App.create!(name: 'John Travolta', street_address: '1111 Greasy Lane', city: 'Frisco', state: 'CO', zip_code: '80678', description: 'I like dogs. Dogs are cool. You should give me a dog.', status: 'Pending')
      @pet_1 = Pet.create!(adoptable: true, age: 4, breed: 'Chihuahua', name: 'Maximus', shelter_id: @shelter_1.id)
      @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    end

    it 'can add a pet to an applications pets' do
      expect(@app_1.pets.count).to eq(0)

      @app_1.apply_adopt(@pet_1.id)
      expect(@app_1.pets.count).to eq(1)
    end
    
    it 'can check for all app_pet approvals and change status to approved' do
      app_pet_1 = AppPet.create(pet_id: @pet_1.id, app_id: @app_1.id, status: "Approved")
      app_pet_2 = AppPet.create(pet_id: @pet_2.id, app_id: @app_1.id)

      @app_1.check_and_update_status
      @app_1 = App.find(@app_1.id)
      expect(@app_1.status).to eq("Pending")

      app_pet_2.update(status: "Approved")
      @app_1.check_and_update_status
      @app_1 = App.find(@app_1.id)
      expect(@app_1.status).to eq("Approved")
    end

    it 'can check for one or more rejections and approvals and change status to rejected' do
      app_pet_1 = AppPet.create(pet_id: @pet_1.id, app_id: @app_1.id, status: "Rejected")
      app_pet_2 = AppPet.create(pet_id: @pet_2.id, app_id: @app_1.id)

      @app_1.check_and_update_status
      @app_1 = App.find(@app_1.id)
      expect(@app_1.status).to eq("Pending")

      app_pet_2.update(status: "Approved")
      @app_1.check_and_update_status
      @app_1 = App.find(@app_1.id)
      expect(@app_1.status).to eq("Rejected")
    end
  end
end