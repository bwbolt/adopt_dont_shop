class ApplicationsController < ApplicationController
  before_action :set_application, only: %i[show update]

  def index
    @applications = Application.all
  end

  def show
    @adoptable_pets = if !params[:pets_by_name].nil? && params[:pets_by_name] != ''
                        Pet.search(params[:pets_by_name]).where(adoptable: true)

                      else
                        []
                      end
  end

  def create
    application = Application.new(application_params)
    if application.save
      flash[:success] = 'Your application has been received.'
      redirect_to "/applications/#{application.id}"
    elsif application.errors.full_messages == ["Name can't be blank"]
      flash[:notice] = 'Please enter your Name'
      render :new
    elsif application.errors.full_messages == ["Address can't be blank"]
      flash[:notice] = 'Please enter your Address'
      render :new
    elsif application.errors.full_messages == ["City can't be blank"]
      flash[:notice] = 'Please enter your City'
      render :new
    elsif application.errors.full_messages == ["State can't be blank"]
      flash[:notice] = 'Please enter your State'
      render :new
    elsif application.errors.full_messages == ["Reason can't be blank"]
      flash[:notice] = 'Why would you like to adopt this pet?'
      render :new
    else
      flash[:notice] = 'Please enter your Zip Code'
      render :new
    end
  end

  def update
    @application.update(status: params[:application_status])
    redirect_to("/applications/#{@application[:id]}")
  end

  private

  def application_params
    params.permit(:name, :address, :city, :state, :zip, :reason)
  end

  def set_application
    @application = Application.find(params[:id])
  end
end
