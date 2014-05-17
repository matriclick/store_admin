json.array!(@supply_purchases) do |supply_purchase|
  json.extract! supply_purchase, :id, :provider_id, :total_paid, :currency_id, :comments
  json.url supply_purchase_url(supply_purchase, format: :json)
end
