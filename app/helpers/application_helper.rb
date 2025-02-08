module ApplicationHelper
  def horarios_disponiveis
    (8..18).map do |hora|
      hora_formatada = format("%02d:00", hora)
      [ hora_formatada, hora_formatada ]
    end
  end
end
