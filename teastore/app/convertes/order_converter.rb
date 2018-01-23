class OrderConverter
  include Converter

  def to_json( order )
    tea_conveter = TeaConverter.new

    teas = order.teas
    converted_teas = "["

    teas.each do |tea|
      converted_teas << tea_conveter.to_json( tea )
    end

    converted_teas << "]"

    client_converter = ClientConverter.new
    client = order.client
    converted_client = client_converter.to_json( client )

    order = "{client:"
    order << converted_client
    order << ", teas:"
    order << converted_teas
    order << "}"

    order
  end

  def from_json( json )
    ActiveSupport::JSON.decode( json )
  end

  def hash_from_json( json )
    ActiveSupport::JSON.decode( json )
  end

  def list_from_json( json )
    ActiveSupport::JSON.decode( json )
  end
end
