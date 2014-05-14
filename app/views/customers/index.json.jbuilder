json.array!(@customers) do |customer|
  json.extract! customer, :id, :name, :rut, :birthday, :phone_number, :supplier_account_id
  json.url customer_url(customer, format: :json)
end
