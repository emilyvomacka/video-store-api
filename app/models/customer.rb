class Customer < ApplicationRecord
  has_many :rentals
  has_many :movies, through: :rentals

  validates :name, presence: :true 
  validates :phone, presence: :true, uniqueness: :true

  #I don't think we need this method anymore! 
  # def movies_checked_out_count 
  #   return self.movies.count
  # end 
end
