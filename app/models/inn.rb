class Inn < ApplicationRecord
  belongs_to :innkeeper
  has_one :address

  validates_presence_of :name, :corporate_name, :registration_number, :description, :usage_policies, :email, :innkeeper_id, :check_in, :check_out
  validates_uniqueness_of :email, :registration_number, :innkeeper

  accepts_nested_attributes_for :address

  after_initialize do |inn|
    inn.enabled = true if inn.enabled.nil?
    inn.pets_are_allowed = inn.pets_are_allowed?
  end
end
