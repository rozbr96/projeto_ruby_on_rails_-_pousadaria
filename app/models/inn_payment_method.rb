class InnPaymentMethod < ApplicationRecord
  belongs_to :inn
  belongs_to :payment_method

  validates_presence_of :inn, :payment_method
  validates_uniqueness_of :payment_method, scope: :inn
end
