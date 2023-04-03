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
      @app_1 = App.create!(name: 'John Travolta', street_address: '1111 Greasy Lane', city: 'Frisco', state: 'CO', zip_code: '80678', description: 'I like dogs. Dogs are cool. You should give me a dog.', status: 'In Progress')
      @pet = Pet.create!(adoptable: true, age: 4, breed: 'Chihuahua', name: 'Maximus', shelter_id: @shelter_1.id)
    end

    it 'can add a pet to an applications pets' do
      expect(@app_1.pets.count).to eq(0)

      @app_1.apply_adopt(@pet.id)
      expect(@app_1.pets.count).to eq(1)
    end
  end
end