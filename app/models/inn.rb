class Inn < ApplicationRecord
  belongs_to :innkeeper
  has_one :address
  has_many :inn_phone_numbers
  has_many :phone_numbers, through: :inn_phone_numbers
  has_many :inn_rooms

  validates_uniqueness_of :email, :registration_number, :innkeeper
  validates_presence_of :name, :corporate_name, :registration_number, :description,
    :usage_policies, :email, :innkeeper_id, :check_in, :check_out

  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :phone_numbers, reject_if: :all_blank

  after_initialize do |inn|
    inn.enabled = true if inn.enabled.nil?
    inn.pets_are_allowed = inn.pets_are_allowed?
  end
end
