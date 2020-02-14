# frozen_string_literal: true

class Rule < ApplicationRecord
  PERIOD_LIST = %w[year month week].freeze

  belongs_to :company
  has_many :events

  validates :allowance_days, numericality: { only_integer: true,
                                             greater_than_or_equal_to: 0 }
  validates :is_enabled, inclusion: { in: [true, false] }
  validates :auto_confirm, inclusion: { in: [true, false] }
  validates :is_holiday, inclusion: { in: [true, false] }
  validates :name, presence: true, uniqueness: { scope: :company_id }
  validates :period, presence: true, inclusion: { in: PERIOD_LIST }
  validates_format_of :color, with: /\A#[0-9a-f]{6}\z/
end
