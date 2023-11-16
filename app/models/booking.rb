class Booking < ApplicationRecord
  belongs_to :inn_room

  validates_presence_of :start_date, :end_date, :guests_number
  validates_numericality_of :guests_number, greater_than: 0
  validate :start_and_end_dates, :overlappinp_dates, :guests_capacity

  enum status: {
    pending: 0,
    ongoing: 1,
    finished: 2,
    canceled: 3
  }

  def estimated_price
    return unless valid?

    custom_prices = inn_room.custom_prices.to_a

    estimated_price = start_date.upto(end_date).map do |date|
      custom_price = custom_prices.find do |custom_price|
        next false if date < custom_price.start_date
        next false if date > custom_price.end_date

        true
      end

      next inn_room.price if custom_price.nil?

      custom_price.price
    end.sum
  end

  def guests_capacity
    return if inn_room.nil?
    return if guests_number.nil?
    return if inn_room.maximum_number_of_guests >= guests_number

    errors.add :guests_number, 'excede a quantidade máxima permitida pelo quarto'
  end

  def overlappinp_dates
    return if inn_room.nil?

    bookings = Booking.where(inn_room: inn_room, status: :ongoing).where.not(id: id)
    invalid_ranges = bookings.map &:reservation_dates_range

    return unless invalid_ranges.any? do |invalid_range|
      invalid_range.overlaps? reservation_dates_range
    end

    errors.add :reservation_dates_range, 'está sobrepondo algum outro período já existente'
  end

  def reservation_dates_range
    start_date..end_date
  end

  def start_and_end_dates
    return if start_date.nil?
    return if end_date.nil?
    return if end_date > start_date

    error = if end_date == start_date
      'não pode ser igual à data inicial'
    else
      'não pode ser anterior à data inicial'
    end

    errors.add :end_date, error
  end
end