require 'net/http'
require 'uri'

class TeaRequester
  BASE_URI = 'https://tea-store.herokuapp.com/api'

  def request_teas
    uri = URI.parse( "#{BASE_URI}/available-teas" )

    response = request( uri )
    response.body
  end

  private
  def request( uri )
    request = Net::HTTP::Get.new( uri )
    request[ "Authorization" ] = 'Token Bandolim@M821912212ejadsa@023'

    response = Net::HTTP.start( uri.host, uri.port, use_ssl: uri.scheme == 'https' ) do |http|
      http.request( request )
    end
    response
  end
end
