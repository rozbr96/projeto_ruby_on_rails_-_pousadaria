class Billing < ApplicationRecord
  belongs_to :payment_method, optional: true
  belongs_to :booking

  has_many :billing_items

  validates_presence_of :base_price, on: :save
  validate :billing_status

  after_initialize do
    self.finished = false

    next unless valid?

    self.base_price = calculated_price
  end

  def billing_status
    return unless finished?
    return unless payment_method.nil?

    errors.add :base, 'Fatura não pode ser encerrada sem um método de pagamento'
  end

  def calculated_price
    today = Time.current
    today = today.tomorrow if today.hour >= booking.inn.check_out.hour and
      today.min > booking.inn.check_out.min

    booking_price = booking.get_real_price today.to_date
    items_price = billing_items.map(&:total_price).sum

    booking_price + items_price
  end
end
