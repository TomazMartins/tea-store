require 'net/http'
require 'uri'

class TeaRequester
  include Requester

  def request_teas
    uri = URI.parse( "#{ BASE_URI }/available-teas" )

    response = request( uri )
    response.body
  end

  private
  def request( uri )
    request = Net::HTTP::Get.new( uri )
    request[ "Authorization" ] = TOKEN

    response = Net::HTTP.start( uri.host, uri.port, use_ssl: uri.scheme == 'https' ) do |http|
      http.request( request )
    end
    response
  end
end
