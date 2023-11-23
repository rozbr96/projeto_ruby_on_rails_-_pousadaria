class Billing < ApplicationRecord
  belongs_to :payment_method, optional: true
  belongs_to :booking

  validates_presence_of :base_price, :payment_method, on: :save

  after_initialize do
    next unless valid?

    self.base_price = calculated_price
  end

  def calculated_price
    today = Time.current
    today = today.tomorrow if today.min > booking.inn.check_out.min

    booking.get_real_price today.to_date
  end
end
