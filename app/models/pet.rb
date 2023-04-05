class Pet < ApplicationRecord
  validates :name, presence: true
  validates :age, presence: true, numericality: true
  belongs_to :shelter
  has_many :app_pets
  has_many :apps, through: :app_pets

  def shelter_name
    shelter.name
  end

  def self.adoptable
    where(adoptable: true)
  end

  def self.update_adoption_status(params)
    app = App.find(params[:id])
    if app.status == "Approved"
      pets = app.pets
      pets.each do |pet|
        pet.update(adoptable: false)
      end
    end
  end
end
