# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts "--> StoreAdminPrivilege:"
aux = []
aux << (StoreAdminPrivilege.find_by_name("Usar Punto de Venta") || StoreAdminPrivilege.create(:name => 'Usar Punto de Venta'))
aux << (StoreAdminPrivilege.find_by_name("Administrar Stock") || StoreAdminPrivilege.create(:name => 'Administrar Stock'))
aux << (StoreAdminPrivilege.find_by_name("Crear Productos") || StoreAdminPrivilege.create(:name => 'Crear Productos'))
aux << (StoreAdminPrivilege.find_by_name("Ver Reportes") || StoreAdminPrivilege.create(:name => 'Ver Reportes'))
aux << (StoreAdminPrivilege.find_by_name("Administrar Usuarios") || StoreAdminPrivilege.create(:name => 'Administrar Usuarios'))
aux << (StoreAdminPrivilege.find_by_name("Administrar Tallas") || StoreAdminPrivilege.create(:name => 'Administrar Tallas'))
aux << (StoreAdminPrivilege.find_by_name("Administrar Categorias") || StoreAdminPrivilege.create(:name => 'Administrar Categorias'))
aux.each { |x| puts x.name }
puts "\n"

puts "--> PaymentMethod:"
aux = []
aux << (PaymentMethod.find_by_name("Tarjeta de Credito") || PaymentMethod.create(:name => 'Tarjeta de Credito'))
aux << (PaymentMethod.find_by_name("Tarjeta de Debito") || PaymentMethod.create(:name => 'Tarjeta de Debito'))
aux << (PaymentMethod.find_by_name("Efectivo") || PaymentMethod.create(:name => 'Efectivo'))
aux << (PaymentMethod.find_by_name("Cheque") || PaymentMethod.create(:name => 'Cheque'))
aux.each { |x| puts x.name }
puts "\n"

puts "--> Roles:"
aux = []
aux << (Role.find_by_name("Admin") || Role.create(:name => 'Admin'))
aux << (Role.find_by_name("Store") || Role.create(:name => 'Store'))
aux.each { |x| puts x.name }
puts "\n"