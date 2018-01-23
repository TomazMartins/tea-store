require 'net/http'
require 'uri'

class OrderRequester
  include Requester

  def send_order( order )
    uri = URI.parse( "#{ BASE_URI }/send-order" )

    header = { 'Content-Type': 'text/json' }

    http = Net::HTTP.new( uri.host, uri.port )
    http.use_ssl = true

    request = Net::HTTP::Post.new( uri.request_uri, header )
    request[ "Authorization" ] = TOKEN
    request.body = order

    http.request( request )
  end
end
