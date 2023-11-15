class Booking < ApplicationRecord
  belongs_to :inn_room

  validates_presence_of :start_date, :end_date, :guests_number
  validates_numericality_of :guests_number, greater_than: 0
  validate :start_and_end_dates, :overlappinp_dates

  enum status: {
    pending: 0,
    ongoing: 1,
    finished: 2,
    canceled: 3
  }

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

    errors.add :end_date, 'não pode ser anterior à data inicial'
  end
end
