# frozen_string_literal: true

class Account < ApplicationRecord
  has_many :employees, dependent: :destroy
  has_many :company, through: :employees

  validates :name, presence: true
  validates :surname, presence: true
  validates :email, presence: true, uniqueness: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
