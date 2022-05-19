class ApplicationsController < ApplicationController
  def index
    @applications = Application.all
  end

  def show
    @application = Application.find(params[:id])
  end

  def new
  end

  def create
    applicant = Application.create(applicant_params)
    redirect_to "/applications"
  end

  private
    def applicant_params
      params.permit(:name, :address, :city, :state, :zip, :reason)
    end
end
