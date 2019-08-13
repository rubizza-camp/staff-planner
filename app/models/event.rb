class Event < ApplicationRecord
  belongs_to :employee
  belongs_to :company
  belongs_to :rule

  validates :employee_id, presence: true
  validates :rule_id, presence: true
  validates :start_period, presence: true
  validates :end_period, presence: true
end