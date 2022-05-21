class AdminSheltersController < ApplicationController

  def index
    @admin_shelters = Shelter.find_by_sql("SELECT * FROM shelters ORDER BY shelters.name desc")
    @pending_applications = Shelter.has_pending_application
  end
end