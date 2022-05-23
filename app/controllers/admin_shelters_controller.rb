class AdminSheltersController < ApplicationController

  def index
    @admin_shelters = Shelter.find_by_sql("SELECT * FROM shelters ORDER BY shelters.name desc")
    @pending_applications = Shelter.has_pending_application
  end

  def show
    @admin_shelter = Shelter.find_by_sql("SELECT shelters.name, shelters.city FROM shelters WHERE shelters.id = #{params[:id]}")
    @shelter_with_pets = Shelter.find(params[:id])
  end
end
