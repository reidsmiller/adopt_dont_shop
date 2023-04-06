class AppsController < ApplicationController
  def show
    @app = App.find(params[:id])
    @pets = @app.pets
    @app_submitted = false
    if params[:search].present?
      @searched_pets = Pet.search(params[:search])
    elsif params[:pet_id].present?
      @app.apply_adopt(params[:pet_id])
    end
    @app_submitted = true if @app.status == "Pending"
  end
  
  def new
  end

  def create
    app = App.new(app_params)
    
    if app.save
      redirect_to "/apps/#{app.id}"
    else
      flash[:notice] = "Application not created: Required information missing."
      render :new
    end
  end

  def update
    app = App.find(params[:id])
    if params[:application_text].present?
      app.update(status: "Pending")
    end
    redirect_to "/apps/#{params[:id]}"
  end


  private
  def app_params
    params.permit(:name, :street_address, :city, :state, :zip_code, :description)
  end
end