require 'uri'
require 'net/http'

class TeaRequester
  BASE_URI = 'https://pokeapi.co/api/v2'

  def request_teas
    uri = URI.parse( "#{BASE_URI}/pokemon/1/" )

    http = Net::HTTP.new( uri.host, uri.port )
    http.use_ssl = true

    request = Net::HTTP::Get.new( uri )
    response = http.request( request )

    response.body
  end
end
