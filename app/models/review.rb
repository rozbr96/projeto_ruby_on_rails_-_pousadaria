class Review < ApplicationRecord
  belongs_to :booking

  validates_numericality_of :score, in: 0..5
  validate :booking_uniqueness

  def replied?
    not innkeeper_reply.nil?
  end


  private

  def booking_uniqueness
    return if booking.nil?
    return if Review.where(booking: booking).where.not(id: id).count.zero?

    errors.add(:base, 'Já existe uma avaliação sobre essa estadia')
  end
end
