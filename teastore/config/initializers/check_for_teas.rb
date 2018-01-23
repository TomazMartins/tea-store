if Tea.all.size.eql? 0
  tea_requester = TeaRequester.new
  teas_json = tea_requester.request_teas

  tea_converter = TeaConverter.new
  teas_hash = tea_converter.hash_from_json( teas_json )

  teas_hash.each do |tea|
    tea[ 'is_menu' ] = true
  end

  Tea.create( teas_hash )
end
