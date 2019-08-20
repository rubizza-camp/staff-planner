# frozen_string_literal: true

class Account < ApplicationRecord
  has_many :employees, dependent: :destroy
  has_many :companies, through: :employees
  has_many :events, through: :employees

  validates :name, presence: true
  validates :surname, presence: true
  validates :email, presence: true, uniqueness: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable,
         authentication_keys: [:email]

  # rubocop: disable Metrics/AbcSize
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |account|
      account.provider = auth.provider
      account.name = auth.info.name
      account.surname = auth.info.nickname
      account.uid = auth.uid
      account.email = auth.info.email
      account.password = Devise.friendly_token[0, 20]
    end
  end
  # rubocop: enable Metrics/AbcSize
end
