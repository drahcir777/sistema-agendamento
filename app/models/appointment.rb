class Appointment < ApplicationRecord
  belongs_to :user
  belongs_to :professional, class_name: "User", foreign_key: "user_id"
  belongs_to :client, class_name: "Client", foreign_key: "client_id"

  validates :date, presence: { message: "Data é obrigatória" }
  validates :time, presence: { message: "Horário é obrigatório" }
  validates :client_name, presence: { message: "Nome do cliente é obrigatório" }
  validates :client_phone, presence: { message: "Telefone do cliente é obrigatório" }
  validate :time_slot_available
  validate :date_and_time_must_be_present

  attr_accessor :time
  attr_accessor :client_name, :client_phone

  private

  def date_and_time_must_be_present
    if date.blank? || time.blank?
      errors.add(:base, "Data e horário são obrigatórios")
    end
  end

  def time_slot_available
    return unless date.present?

    existing_appointment = Appointment.where(
      user_id: user_id,
      date: date
    ).where.not(id: id).exists?

    if existing_appointment
      errors.add(:date, "Este horário já está agendado")
    end
  end
end
