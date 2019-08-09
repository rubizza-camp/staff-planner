# frozen_string_literal: true

class Company < ApplicationRecord
  has_many :employees, dependent: :destroy
  has_many :rules, dependent: :destroy
  has_many :working_days, dependent: :destroy

  validates :name, presence: true
end
