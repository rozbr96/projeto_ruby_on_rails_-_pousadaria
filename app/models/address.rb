class Address < ApplicationRecord
  belongs_to :inn

  validates_presence_of :street, :neighbourhood, :city, :state, :postal_code

  def full_address
    number_text = number.nil? ? "sem número" : "nº #{number}"
    complement_text = ", #{complement}" unless complement.nil?

    "#{street}, #{number_text}#{complement_text} - #{neighbourhood}, #{city} - #{state}, #{postal_code}"
  end
end
