class InnPhoneNumber < ApplicationRecord
  belongs_to :inn
  belongs_to :phone_number

  validates_uniqueness_of :phone_number, scope: :inn
end
