class Billing < ApplicationRecord
  belongs_to :payment_method, optional: true
  belongs_to :booking

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
    today = today.tomorrow if today.min > booking.inn.check_out.min

    booking.get_real_price today.to_date
  end
end
