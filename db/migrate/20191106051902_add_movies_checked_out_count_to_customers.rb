class AddMoviesCheckedOutCountToCustomers < ActiveRecord::Migration[5.2]
  def change
    add_column :customers, :movies_checked_out_count, :integer, default: 0
  end
end
