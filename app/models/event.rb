# frozen_string_literal: true

class Event < ApplicationRecord
  START_DAY = 9
  HALF_DAY = 13
  END_DAY = 21

  belongs_to :employee
  belongs_to :company
  belongs_to :rule
  has_one :account, through: :employee

  scope :range,
        ->(start_day, end_day) { where('GREATEST( start_period, ? ) < LEAST( end_period, ? )', start_day, end_day) }

  validates :employee_id, presence: true
  validates :rule_id, presence: true
  validates :start_period, presence: true
  validates :end_period, presence: true
end
