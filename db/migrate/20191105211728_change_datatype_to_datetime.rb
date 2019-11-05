class ChangeDatatypeToDatetime < ActiveRecord::Migration[5.2]
  def change
    
    remove_column :customers, :registered_at
    remove_column :movies, :release_date
    
    add_column :customers, :registered_at, :datetime 
    add_column :movies, :release_date, :date
  end
end

