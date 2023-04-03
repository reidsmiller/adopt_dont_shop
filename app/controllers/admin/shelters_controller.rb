class Admin::SheltersController < ApplicationController
  def index
    @shelters = Shelter.order_alphabetically_reverse
    @pending_shelters = Shelter.select_pending_shelters
  end

  def show
    @shelter = Shelter.info_by_shelter_id(params)    
  end
end