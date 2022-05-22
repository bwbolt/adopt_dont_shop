class ApplicationPetsController < ApplicationController
  def create
    ApplicationPet.create(application_id: params[:application_id], pet_id: params[:pet_id])
    redirect_to "/applications/#{params[:application_id]}"
  end

  def update
    application_pet = ApplicationPet.find(params[:id])
    application = Application.find(params[:application_id])
    application_pet.update(approval: true) if params[:commit] == 'Approve'
    if params[:commit] == 'Reject'
      application_pet.update(approval: false)
      application.update(status: 'Rejected')
    end
    if application.application_pets.pluck(:approval).all?(true)
      application.update(status: 'Approved')
    end
    redirect_to "/admin/applications/#{params[:application_id]}"
  end
end
