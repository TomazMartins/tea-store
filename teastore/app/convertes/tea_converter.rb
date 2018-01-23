class TeaConverter
  include Converter

  def to_json( tea )
    tea.id = Tea.find_by_name( tea.name ).id

    tea = tea.attributes.except( 'made_in', 'stock_quantity', 'drink_with_milk', 'name', 'type',
        'created_at', 'updated_at', 'price', 'order_id', 'is_menu', 'steeping_time' )

    tea = ActiveSupport::JSON.encode( tea )

    tea.gsub( 'ordered_quantity', 'quantity' )
  end

  def from_json( json )
    object = JSON.parse( json, object_class: OpenStruct )

    tea = Tea.new( name: object.name, type: get_type( object ), price: object.price,
        made_in: object.made_in, steeping_time: object.steeping_time,
        drink_with_milk: object.drink_with_milk, stock_quantity: object.stock_quantity )

    tea
  end

  def hash_from_json( json )
    hash = JSON.parse( json )

    hash.each do |object|
      if object['type'].eql? 'chai'
        object['type'] = 'ChaiTea'
      else
        object['type'] = object['type'].gsub( ' ', '_' ).camelize
      end
    end

    hash
  end

  def list_from_json( json )
    object_json = JSON.parse( json, object_class: OpenStruct )
    @teas = []

    object_json.each do |object|
      tea = Tea.new( name: object.name, type: get_type( object ), price: object.price,
          made_in: object.made_in, steeping_time: object.steeping_time,
          drink_with_milk: object.drink_with_milk, stock_quantity: object.stock_quantity )

      @teas << tea
    end

    @teas
  end

  private
  def get_type( object_json )
    type = object_json.type

    if type.eql? 'chai'
      type = 'ChaiTea'
    else
      type = type.gsub( ' ', '_' ).camelize
    end

    type
  end
end
