class InnRoom < ApplicationRecord
  belongs_to :inn

  validates_presence_of :name, :description, :dimension, :price,
    :maximum_number_of_guests, :number_of_bathrooms, :number_of_wardrobes

  after_initialize do |room|
    room.enabled = room.enabled?
    room.has_air_conditioning = room.has_air_conditioning?
    room.has_balcony = room.has_balcony?
    room.has_tv = room.has_tv?
    room.has_vault = room.has_vault?
    room.is_accessible_for_people_with_disabilities = room.is_accessible_for_people_with_disabilities?
  end
end
