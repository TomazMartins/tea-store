namespace :scheduled_taks do
  task request_teas: :environment do
    Tea.destroy_all

    tea_requester = TeaRequester.new
    teas_json = tea_requester.request_teas

    tea_converter = TeaConverter.new
    teas_hash = tea_converter.hash_from_json( teas_json )

    Tea.create( teas_hash )
  end
end
