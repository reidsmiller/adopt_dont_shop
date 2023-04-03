class Admin::AppsController < ApplicationController
  def show
    @app = App.find(params[:id])
    @pets = @app.pets
    if params[:pet_id].present?
      Pet.find(params[:pet_id]).approve_adoption
    end
  end
end