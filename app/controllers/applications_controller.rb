class ApplicationsController < ApplicationController
  def index
    @applications = Application.all
  end

  def show
    @application = Application.find(params[:id])
    @adoptable_pets = if !params[:pets_by_name].nil? && params[:pets_by_name] != ''
                        Pet.where(name: params[:pets_by_name])
                      else
                        []
                      end
  end

  def new; end

  def create
    applicant = Application.new(applicant_params)
    if applicant.save
      flash[:success] = 'Your application has been received.'
      redirect_to '/applications'
    elsif applicant.errors.full_messages == ["Name can't be blank"]
      flash[:notice] = 'Please enter your Name'
      render :new
    elsif applicant.errors.full_messages == ["Address can't be blank"]
      flash[:notice] = 'Please enter your Address'
      render :new
    elsif applicant.errors.full_messages == ["City can't be blank"]
      flash[:notice] = 'Please enter your City'
      render :new
    elsif applicant.errors.full_messages == ["State can't be blank"]
      flash[:notice] = 'Please enter your State'
      render :new
    elsif applicant.errors.full_messages == ["Zip can't be blank"]
      flash[:notice] = 'Please enter your Zip Code'
      render :new
    elsif applicant.errors.full_messages == ["Reason can't be blank"]
      flash[:notice] = 'Why would you like to adopt this pet?'
      render :new
    end
  end

  private

  def applicant_params
    params.permit(:name, :address, :city, :state, :zip, :reason)
  end
end
