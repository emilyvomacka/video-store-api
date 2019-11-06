class AddAvailInventoryToMovies < ActiveRecord::Migration[5.2]
  def change
    add_column :movies, :available_inventory, :integer
  end
end
