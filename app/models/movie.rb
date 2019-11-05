class Movie < ApplicationRecord
  has_many :rentals
  has_many :customers, through: :rentals

  validates :title, presence: :true
  validates :inventory, presence: :true, numericality: { only_integer: true, greater_than: -1 }
end
