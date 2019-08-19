# frozen_string_literal: true

class Holiday < ApplicationRecord
  belongs_to :company

  validates :name, presence: true
  validates :date, presence: true
  validate  :date_cannot_be_in_the_past
  
  def date_cannot_be_in_the_past
    return if !date || date > Date.today

    errors.add(:date, 'Can\'t be in the past')
  end
end
