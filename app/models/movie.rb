class Movie < ApplicationRecord
  has_many :customers, through: :rentals
end
