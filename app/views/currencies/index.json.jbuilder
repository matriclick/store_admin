json.array!(@currencies) do |currency|
  json.extract! currency, :id, :symbol, :name, :supplier_account_id
  json.url currency_url(currency, format: :json)
end
