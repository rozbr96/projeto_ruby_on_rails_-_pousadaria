class Booking < ApplicationRecord
  # TODO add 8-length random code attribute

  belongs_to :inn_room
  belongs_to :guest, optional: true

  has_one :inn, through: :inn_room

  validates_presence_of :start_date, :end_date, :guests_number
  validates_presence_of :guest, on: :save
  validates_numericality_of :guests_number, greater_than: 0
  validate :start_and_end_dates, :overlappinp_dates, :guests_capacity
  validates_uniqueness_of :code
  validates_length_of :code, is: 8, if: :code

  before_save :generate_random_code, :set_estimated_price

  enum status: {
    pending: 0,
    reserved: 1,
    ongoing: 2,
    finished: 3,
    canceled: 4
  }

  def generate_random_code
    self.code ||= SecureRandom.alphanumeric(8).upcase
  end

  def get_estimated_price
    return unless valid?

    custom_prices = inn_room.custom_prices.to_a

    start_date.upto(end_date).map do |date|
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

    bookings = Booking.where(inn_room: inn_room, status: [:reserved, :ongoing])

    invalid_ranges = bookings.map &:reservation_dates_range

    return unless invalid_ranges.any? do |invalid_range|
      invalid_range.overlaps? reservation_dates_range
    end

    errors.add :reservation_dates_range, 'está sobrepondo algum outro período já existente'
  end

  def reservation_dates_range
    start_date..end_date
  end

  def set_estimated_price
    return unless valid?

    self.estimated_price ||= get_estimated_price
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
