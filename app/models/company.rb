# frozen_string_literal: true

class Company < ApplicationRecord
  validates :name, presence: true
  has_many :employees, dependent: :destroy
  has_many :rules
  has_many :working_day
end
