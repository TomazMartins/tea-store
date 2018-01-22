namespace :scheduled_taks do
  task request_teas: :environment do
    tea_requester = TeaRequester.new
    teas = tea_requester.request_teas

    teas.each do |tea|
      tea.save
    end
  end
end
