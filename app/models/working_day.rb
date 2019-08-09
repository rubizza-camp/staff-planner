# frozen_string_literal: true

class WorkingDay < ApplicationRecord
  belongs_to :company

  validates :day_of_week, presence: true,
                          inclusion: { in: 0..6 },
                          uniqueness: { scope: :company_id, message: 'already used' }
end
