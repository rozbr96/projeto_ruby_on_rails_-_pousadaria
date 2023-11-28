class BillingItem < ApplicationRecord
  belongs_to :billing

  validates_presence_of :description, :amount, :unit_price
  validates_numericality_of :amount, :unit_price, greater_than: 0
end
