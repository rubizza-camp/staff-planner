# frozen_string_literal: true

class Rule < ApplicationRecord
  validates :company_id, presence: true
  validates :name, presence: true
  validates :period, presence: true
  belongs_to :company
end
