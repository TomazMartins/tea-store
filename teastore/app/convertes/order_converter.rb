class OrderConverter
  include Converter

  def to_json( order )
    tea_conveter = TeaConverter.new

    teas = order.teas
    converted_teas = []

    teas.each do |tea|
      converted_teas << tea_conveter.to_json( tea )
    end


    ActiveSupport::JSON.encode( order )
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
