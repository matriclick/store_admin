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
SupplierAccount.all.each do |supplier_account|
  aux = []
  aux << (PaymentMethod.find_by_name_and_supplier_account_id("Tarjeta de Credito", supplier_account.id) || PaymentMethod.create(:name => 'Tarjeta de Credito', supplier_account_id: supplier_account.id))
  aux << (PaymentMethod.find_by_name_and_supplier_account_id("Tarjeta de Debito", supplier_account.id) || PaymentMethod.create(:name => 'Tarjeta de Debito', supplier_account_id: supplier_account.id))
  aux << (PaymentMethod.find_by_name_and_supplier_account_id("Efectivo", supplier_account.id) || PaymentMethod.create(:name => 'Efectivo', supplier_account_id: supplier_account.id))
  aux << (PaymentMethod.find_by_name_and_supplier_account_id("Cheque", supplier_account.id) || PaymentMethod.create(:name => 'Cheque', supplier_account_id: supplier_account.id))
  aux.each { |x| puts x.name }
  puts "\n"
end

puts "--> Provider:"
SupplierAccount.all.each do |supplier_account|
  aux = []
  aux << (Provider.find_by_name_and_supplier_account_id("Sin Proveedor", supplier_account.id) || Provider.create(:name => 'Sin Proveedor', address: 'Sin asignar', supplier_account_id: supplier_account.id))
  aux.each { |x| puts x.name }
  puts "\n"
end

puts "--> Roles:"
aux = []
aux << (Role.find_by_name("Admin") || Role.create(:name => 'Admin'))
aux << (Role.find_by_name("Store") || Role.create(:name => 'Store'))
aux.each { |x| puts x.name }
puts "\n"