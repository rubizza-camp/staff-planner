# frozen_string_literal: true

class Employee < ApplicationRecord
  validates :start_day, presence: true
  validates :is_enabled, presence: true
  validates :account_id
  validates :company_id

  belongs_to :account
  belongs_to :company
end
