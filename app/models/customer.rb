class Customer < ApplicationRecord
  has_many :movies, through: :rentals
end
