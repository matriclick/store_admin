json.array!(@gift_cards) do |gift_card|
  json.extract! gift_card, :id, :customer_id, :barcode, :amount, :valid_until, :status, :user_id
  json.url gift_card_url(gift_card, format: :json)
end
