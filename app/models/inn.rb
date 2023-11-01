class Inn < ApplicationRecord
  belongs_to :innkeeper

  validates_presence_of :name, :corporate_name, :registration_number, :description, :usage_policies, :email, :innkeeper_id, :check_in, :check_out
  validates_uniqueness_of :email, :registration_number, :innkeeper

  after_initialize do |inn|
    inn.enabled = true if inn.enabled.nil?
  end
end
