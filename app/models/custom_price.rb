class CustomPrice < ApplicationRecord
  belongs_to :inn_room

  validates_presence_of :start_date, :end_date, :price
  validate :overlappinp_dates, :start_and_end_dates

  def overlappinp_dates
    return if inn_room.nil?

    prices = CustomPrice.where(inn_room: inn_room).where.not(id: id)
    invalid_ranges = prices.map &:reservation_dates_range

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
    return if end_date >= start_date

    errors.add :end_date, 'não pode ser anterior à data inicial'
  end
end
