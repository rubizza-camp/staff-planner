# frozen_string_literal: true

class Rule < ApplicationRecord
  validates :name, presence: true, uniqueness: { scope: :company_id }
  validates :period, presence: true, inclusion: { in: %w[year month week] }
  validates :alowance_days, numericality: { only_integer: true,
                                            greater_than_or_equal_to: 0 }

  belongs_to :company
end
