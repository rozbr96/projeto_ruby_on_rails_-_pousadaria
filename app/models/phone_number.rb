class PhoneNumber < ApplicationRecord
  validates_presence_of :name, :city_code, :number
  validates_uniqueness_of :number, scope: :city_code

  def formatted
    "(#{city_code}) #{number}"
  end
end
