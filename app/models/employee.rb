# frozen_string_literal: true

class Employee < ApplicationRecord
  validates :start_day, presence: true
  validates :is_enabled, presence: true
  validates :account_id, presence: true
  validates :company_id, presence: true

  belongs_to :account
  belongs_to :company
end
