require 'rails_helper'

RSpec.describe Pet, type: :model do
  describe 'relationships' do
    it { should belong_to :shelter }
    it { should have_many :app_pets}
    it { should have_many(:apps).through(:app_pets)}
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:age) }
    it { should validate_numericality_of(:age) }
  end

  before(:each) do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @app_1 = App.create!(name: 'John Travolta', street_address: '1111 Greasy Lane', city: 'Frisco', state: 'CO', zip_code: '80678', description: 'I like dogs. Dogs are cool. You should give me a dog.')
    @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @pet_3 = @shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 3, adoptable: false)
  end

  describe 'class methods' do
    describe '#search' do
      it 'returns partial matches' do
        expect(Pet.search("Claw")).to eq([@pet_2])
      end
    end

    describe '#adoptable' do
      it 'returns adoptable pets' do
        expect(Pet.adoptable).to eq([@pet_1, @pet_2])
      end
    end
  end

  describe 'instance methods' do
    describe '.shelter_name' do
      it 'returns the shelter name for the given pet' do
        expect(@pet_3.shelter_name).to eq(@shelter_1.name)
      end
    end

    describe '.pet_status_change' do
      it 'changes adoptable status when an application is approved' do
        app_pet_1 = AppPet.create(pet_id: @pet_1.id, app_id: @app_1.id, status: "Approved")
        app_1 = @app_1.update(status: "Approved")
        Pet.update_adoption_status({id: @app_1.id})
        pet_1 = Pet.find(@pet_1.id)
        expect(pet_1.adoptable).to eq(false)
      end
    end
  end
end
