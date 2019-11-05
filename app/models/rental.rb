class Rental < ApplicationRecord
  belongs_to :movie
  belongs_to :customer
end
