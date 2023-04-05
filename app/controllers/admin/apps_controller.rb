class Admin::AppsController < ApplicationController
  def show
    @app = App.find(params[:id])
    @pets = @app.pets
    @app_pets = AppPet.where('app_id = ?', params[:id])
    @app.check_and_update_status
    if params[:commit].present?
      AppPet.change_status(params)
    end
  end
end