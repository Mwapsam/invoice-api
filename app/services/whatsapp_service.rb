require 'uri'
require 'net/http'

class WhatsappService
  ULTRAMSG_API_URL = 'https://api.ultramsg.com/instance64415/messages/chat'.freeze

  def initialize(api_token)
    @api_token = api_token
  end

  def send_message(to_phone_number, message_body)
    uri = URI(ULTRAMSG_API_URL)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri)
    request['content-type'] = 'application/x-www-form-urlencoded'

    form_data = URI.encode_www_form(
      token: @api_token,
      to: to_phone_number,
      body: message_body
    )

    request.body = form_data

    response = http.request(request)

    return { success: true, message: 'WhatsApp message sent successfully' } if response.is_a?(Net::HTTPSuccess)

    { success: false, error: 'Failed to send WhatsApp message' }
  rescue StandardError => e
    { success: false, error: e.message }
  end
end
