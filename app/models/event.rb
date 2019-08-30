# frozen_string_literal: true

class Event < ApplicationRecord
  include AASM

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
  validates :state, presence: true, inclusion: { in: %w[pending accepted declined] }

  aasm column: 'state', whiny_transitions: false do
    state :pending, initial: true
    state :accepted, :declined

    event :accept do
      transitions from: :pending, to: :accepted
    end

    event :decline do
      transitions from: :pending, to: :declined
    end
  end
end
