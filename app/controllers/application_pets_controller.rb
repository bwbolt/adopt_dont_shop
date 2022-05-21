class ApplicationPetsController < ApplicationController
  def create
    ApplicationPet.create(application_id: params[:application_id], pet_id: params[:pet_id])
    redirect_to "/applications/#{params[:application_id]}"
  end

  def update
    application_pet = ApplicationPet.find(params[:id])
    application_pet.update(approval: true) if params[:commit] == 'Approve'
    application_pet.update(approval: false) if params[:commit] == 'Reject'
    redirect_to "/admin/applications/#{params[:application_id]}"
  end
end
