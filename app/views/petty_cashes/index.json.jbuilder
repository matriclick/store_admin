json.array!(@petty_cashes) do |petty_cash|
  json.extract! petty_cash, :id, :close_date, :close_amount, :supplier_account_id, :user_id
  json.url petty_cash_url(petty_cash, format: :json)
end
