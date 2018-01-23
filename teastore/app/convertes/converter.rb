require 'uri'
require 'ostruct'

module Converter
  def to_json( object )
    raise 'Not Implemented'
  end

  def from_json( json )
    raise 'Not Implemented'
  end

  def hash_from_json( json )
    raise 'Not Implemented'
  end

  def list_from_json( json )
    raise 'Not Implemented'
  end
end
