# frozen_string_literal: true

class Company < ApplicationRecord
  has_many :employees, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :holidays, dependent: :destroy
  has_many :rules, dependent: :destroy
  has_many :working_days, dependent: :destroy

  has_many :accounts, through: :employees

  has_one :slack_notification, dependent: :destroy

  validates :name, presence: true
end
