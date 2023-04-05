class Shelter < ApplicationRecord
  validates :name, presence: true
  validates :rank, presence: true, numericality: true
  validates :city, presence: true

  has_many :pets, dependent: :destroy
  has_many :apps, through: :pets

  def self.order_by_recently_created
    order(created_at: :desc)
  end

  def self.order_by_number_of_pets
    select("shelters.*, count(pets.id) AS pets_count")
      .joins("LEFT OUTER JOIN pets ON pets.shelter_id = shelters.id")
      .group("shelters.id")
      .order("pets_count DESC")
  end

  def self.order_alphabetically_reverse
    find_by_sql("SELECT * FROM shelters ORDER BY shelters.name desc")
  end

  def self.select_pending_shelters
    joins(pets: :apps).where('apps.status = ?', 'Pending').distinct
  end

  def pet_count
    pets.count
  end

  def adoptable_pets
    pets.where(adoptable: true)
  end

  def alphabetical_pets
    adoptable_pets.order(name: :asc)
  end

  def shelter_pets_filtered_by_age(age_filter)
    adoptable_pets.where('age >= ?', age_filter)
  end

  def self.info_by_shelter_id(params)
    find_by_sql("SELECT * FROM shelters WHERE id = #{params[:id]}").first
  end

  def avg_pet_age
    adoptable_pets = self.pets.where(adoptable: true)
    adoptable_pets.average(:age)

  def self.order_alphabetically
    order(name: :asc)

  end
end
