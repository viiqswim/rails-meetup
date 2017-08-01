json.users @users do |user|
  json.first_name user.first_name
  json.last_name user.last_name
  json.role user.role(@group.id).name
end