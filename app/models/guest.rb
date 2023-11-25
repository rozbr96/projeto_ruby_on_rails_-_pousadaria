class Guest < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates_presence_of :name, :citizen_number
  validates_uniqueness_of :citizen_number

  has_many :bookings
  has_many :reviews, through: :bookings
end
