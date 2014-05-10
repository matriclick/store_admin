json.array!(@products) do |product|
  json.extract! product, :id, :name, :description, :price, :cost, :supplier_account_id
  json.url product_url(product, format: :json)
end
