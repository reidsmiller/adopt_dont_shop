class Admin::AppsController < ApplicationController
  def show
    @app = App.find(params[:id])
    @pets = @app.pets
    @app_pets = AppPet.where('app_id = ?', params[:id])
  end
  
  def update
    AppPet.change_status(params)
    App.find(params[:id]).check_and_update_status
    redirect_to "/admin/apps/#{params[:id]}"
  end
end