every 1.day, at: '00:00 am' do
  rake 'scheduled_taks:request_teas', environment: 'development'
end
