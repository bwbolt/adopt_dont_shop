class AdminSheltersController < ApplicationController

  def index
    @admin_shelters = Shelter.find_by_sql("SELECT * FROM shelters ORDER BY shelters.name desc")
  end
end
