# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

begin
  admin_login = "admin"
  admin_password = "kpi-asoiu"

  FactoryGirl.create(:user_admin, login: admin_login, password: admin_password)
  puts "Admin with login: '#{admin_login}' and password '#{admin_password}' was created"
rescue Exception => e
  puts "Admin creation was failed with message: '#{e.message}'"
end
