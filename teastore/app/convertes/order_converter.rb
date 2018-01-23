class OrderConverter
  include Converter

  def to_json( order )
    ActiveSupport::JSON.encode( tea )
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
