json.users @users do |user|
  unless user.is_organizer?(@group.id)
    next
  end
  json.first_name user.first_name
  json.last_name user.last_name
  json.role user.role(@group.id).name
end