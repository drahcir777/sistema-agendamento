class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :phone, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true

  has_many :appointments_as_professional, class_name: "Appointment", foreign_key: "user_id"
  has_many :appointments_as_client, class_name: "Appointment", foreign_key: "client_id"
  has_many :services

  before_save :format_phone_number

  def admin?
    self.admin
  end

  def professional?
    !self.admin
  end

  def email_required?
    true
  end

  def will_save_change_to_email?
    true
  end

  private

  def format_phone_number
    self.phone = phone.gsub(/\D/, "")
  end
end
