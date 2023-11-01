class Address < ApplicationRecord
  belongs_to :inn

  validates_presence_of :street, :neighbourhood, :city, :state, :postal_code
end
