json.array!(@users) do |user|
  json.extract! user, :id
  json.url admin_user_url(user, format: :json)
end
