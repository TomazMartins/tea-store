require 'net/http'
require 'ostruct'
require 'uri'

class TeaRequester
  BASE_URI = 'https://tea-store.herokuapp.com/api'

  def request_teas
    uri = URI.parse( "#{BASE_URI}/available-teas" )

    response = request( uri )

    convert_tea_from( response )
  end

  private
    def convert_teas_from( json )
      json_object = JSON.parse( json, object_class: OpenStruct )

      teas = []

      json_object.each do |object|
        teas << Tea.new( category: object.category, price: object.price, is_menu: true )
      end

      teas
    end

    def request( uri )
      http = Net::HTTP.new( uri.host, uri.port )
      http.use_ssl = true

      request = Net::HTTP::Get.new( uri )
      response = http.request( request )

      response.body
    end
end
