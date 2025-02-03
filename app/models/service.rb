class Service < ApplicationRecord
  def duration_hours
    (duration || 0) / 60
  end

  def duration_minutes
    (duration || 0) % 60
  end

  def duration_hours=(hours)
    @duration_hours = hours.to_i
  end

  def duration_minutes=(minutes)
    @duration_minutes = minutes.to_i
  end

  before_save :calculate_duration

  def formatted_duration
    hours = duration_hours
    minutes = duration_minutes
    "#{hours} horas e #{minutes} minutos"
  end

  private

  def calculate_duration
    self.duration = (@duration_hours.to_i * 60) + @duration_minutes.to_i
  end
end
