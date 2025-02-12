class Admin::SheltersController < ApplicationController
  def index
    @shelters = Shelter.order_alphabetically_reverse
    @pending_shelters = Shelter.select_pending_shelters.order_alphabetically
  end

  def show
    @shelter = Shelter.info_by_shelter_id(params)    
    @pets_avg = @shelter.avg_pet_age
    @adp_pets_count = @shelter.count_adp_pets
    @adopted_pets = @shelter.adopted_count
  end

  

end