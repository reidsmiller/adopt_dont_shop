class AppPet < ApplicationRecord
  belongs_to :app
  belongs_to :pet

  def self.change_status(params)
    app_pet = where("pet_id = ? and app_id = ?", params[:pet_id], params[:id]).first
    if params[:commit] == "Approve"
      app_pet.update(status: "Approved")
    elsif params[:commit] == "Reject"
      app_pet.update(status: "Rejected")
    end
  end

  def self.match_pet_to_app_pet(pet_id)
    if Pet.find(pet_id).adoptable == true
      where("pet_id = ?", pet_id).first.status
    else
      return "Adopted"
    end
  end
end