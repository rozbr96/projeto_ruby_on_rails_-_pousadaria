class Review < ApplicationRecord
  belongs_to :booking

  validates_numericality_of :score, in: 0..5
end
