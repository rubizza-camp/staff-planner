class WorkingDay < ApplicationRecord
  validates :day_of_week, presence: true, inclusion: { in: 1..7 }

  belongs_to :company
end
