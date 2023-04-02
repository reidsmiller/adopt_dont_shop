class Admin::SheltersController < ApplicationController
  def index
    @shelters = Shelter.order_alphabetically_reverse
  end
end