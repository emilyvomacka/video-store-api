class CreateRentals < ActiveRecord::Migration[5.2]
  def change
    create_table :rentals do |t|
      t.datetime :checkout_date
      t.datetime :due_date
      t.boolean :returned
      t.belongs_to :movie
      t.belongs_to :customer
      
      t.timestamps
    end
  end
end
