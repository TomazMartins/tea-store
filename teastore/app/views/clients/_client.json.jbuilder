json.extract! client, :id, :name, :email, :country, :created_at, :updated_at
json.url client_url(client, format: :json)
