class Holiday < ApplicationRecord
  belongs_to :company

  validates :name, presence: true
  validates :date, presence: true
  validate  :date, :date_cannot_be_in_the_past

  def date_cannot_be_in_the_past
    if date <= Date.today
      errors.add(:date, 'Can\'t be in the past')
    end
  end
end
