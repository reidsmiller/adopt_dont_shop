class Admin::AppsController < ApplicationController
  def show
    @app = App.find(params[:id])
    @pets = @app.pets
    @app_pets = AppPet.where('app_id = ?', params[:id])
    if params[:commit].present?
      AppPet.change_status(params)
    end
  end
end