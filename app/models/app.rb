class App < ApplicationRecord
  validates :name, presence: true
  validates :street_address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip_code, presence: true
  validates :description, presence: true
  has_many :app_pets
  has_many :pets, through: :app_pets

  def apply_adopt(p_input_id)
    AppPet.create(app_id: id, pet_id: p_input_id)
  end

  def check_and_update_status
    app_pets = AppPet.where('app_id = ?', id)
    total_app_pets = app_pets.count
    approved_app_pets = app_pets.where(status: "Approved").count
    rejected_app_pets = app_pets.where(status: "Rejected").count
    if total_app_pets == approved_app_pets
      self.update(status: 'Approved')
    elsif rejected_app_pets > 0 && rejected_app_pets + approved_app_pets == total_app_pets
      self.update(status: 'Rejected')
    end
  end
end