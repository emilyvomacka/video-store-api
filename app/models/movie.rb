class Movie < ApplicationRecord
  has_many :rentals
  has_many :customers, through: :rentals

  validates :title, presence: :true
  validates :inventory, presence: :true, numericality: { only_integer: true, greater_than: -1 }

  def available_inventory_update(quantity)
    self.update(available_inventory: self.available_inventory + quantity)
  end 
end 