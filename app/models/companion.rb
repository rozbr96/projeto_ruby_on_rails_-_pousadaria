class Companion < ApplicationRecord
  belongs_to :booking

  validates_presence_of :document_number, :document_type, :name
  validates_uniqueness_of :document_number, scope: :booking

  enum document_type: ['CPF', 'RG']
end
