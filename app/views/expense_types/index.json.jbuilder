json.array!(@expense_types) do |expense_type|
  json.extract! expense_type, :id, :name, :description
  json.url expense_type_url(expense_type, format: :json)
end
