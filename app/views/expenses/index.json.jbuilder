json.array!(@expenses) do |expense|
  json.extract! expense, :id, :amount, :currency_id, :expense_type_id, :paid_by, :pay_date, :paid, :comments
  json.url expense_url(expense, format: :json)
end
