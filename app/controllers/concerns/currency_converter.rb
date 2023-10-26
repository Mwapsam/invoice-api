require 'uri'
require 'net/http'
require 'json'

module CurrencyConverter
  def self.convert(from_currency, to_currency, amount)
    url = URI("https://currency-conversion-and-exchange-rates.p.rapidapi.com/convert?from=#{from_currency}&to=#{to_currency}&amount=#{amount}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request['X-RapidAPI-Key'] = '1ab895d1c2msh4e3b78950f389a2p1bacddjsnc46bdf4f62a2'
    request['X-RapidAPI-Host'] = 'currency-conversion-and-exchange-rates.p.rapidapi.com'

    response = http.request(request)

    raise "API request failed with status code: #{response.code}" unless response.code == '200'

    data = JSON.parse(response.read_body)

    return data['result'] if data.is_a?(Hash) && data.key?('result')

    raise "API request failed: Unexpected response structure - #{data}"
  rescue StandardError => e
    raise "API request failed: #{e.message}"
  end
end
