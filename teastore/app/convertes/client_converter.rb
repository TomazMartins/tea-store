class ClientConverter
  include Converter

  def to_json( client )
    client = client.attributes.except( 'created_at', 'updated_at', 'id' )
    ActiveSupport::JSON.encode( client )
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
