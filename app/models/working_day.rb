# frozen_string_literal: true

class WorkingDay < ApplicationRecord
  validates :day_of_week, presence: true, inclusion: { in: 1..7 },
                          uniqueness: { scope: :company_id, message: 'already used' }

  belongs_to :company
end
