require "http"

class WhatsappNotificationService
  def self.send_message(to:, message:, confirmation_url: nil)
    Rails.logger.info "Enviando WhatsApp para #{to}: #{message}"

    formatted_message = message.gsub(/(https?:\/\/[^\s]+)/, '[Clique aqui](\1)')

    response = HTTP.post("http://localhost:3001/enviar", json: {
      numero: "556294721583",
      mensagem: formatted_message,
      link: confirmation_url
    })

    response.status.success?
  rescue => e
    Rails.logger.error "Erro ao enviar WhatsApp: #{e.message}"
    false
  end
end
