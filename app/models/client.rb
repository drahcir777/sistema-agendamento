class Client < ApplicationRecord
  has_many :appointments

  validates :name, presence: true
  validates :phone, presence: true, uniqueness: true
end
