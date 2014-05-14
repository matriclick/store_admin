json.array!(@daily_store_data) do |daily_store_datum|
  json.extract! daily_store_datum, :id, :date, :came_in_clients, :supplier_account_id
  json.url daily_store_datum_url(daily_store_datum, format: :json)
end
