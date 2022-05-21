class AddApprovalToApplicationPets < ActiveRecord::Migration[5.2]
  def change
    add_column :application_pets, :approval, :boolean
  end
end
