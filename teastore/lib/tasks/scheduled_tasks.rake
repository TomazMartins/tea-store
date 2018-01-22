namespace :scheduled_taks do
  task request_teas: :environment do
    tea_requester = TeaRequester.new
    response = tea_requester.request_teas

    Tea.create( category: response, price: 10.0, is_menu: true )
  end
end
