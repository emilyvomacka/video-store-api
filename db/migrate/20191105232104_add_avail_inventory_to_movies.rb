class AddAvailInventoryToMovies < ActiveRecord::Migration[5.2]
  def change
    add_column :movies, :avail_inventory, :integer
  end
end
