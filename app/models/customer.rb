class Customer < ApplicationRecord
  has_many :rentals
  has_many :movies, through: :rentals
  
  validates :name, presence: :true 
  validates :phone, presence: :true, uniqueness: :true

  def movies_checked_out_update(quantity)
    self.update(movies_checked_out_count: self.movies_checked_out_count + quantity)
  end 
end
