# frozen_string_literal: true

class Account < ApplicationRecord
  validates :name, presence: true
  validates :surname, presence: true
end
