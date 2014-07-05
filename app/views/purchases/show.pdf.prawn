logopath = "#{Rails.root}/public"+@supplier_account.logo.url(:medium)
initial_y = pdf.cursor
initialmove_y = 5
address_x = 35
invoice_header_x = 325
lineheight_y = 12
font_size = 9

pdf.move_down initialmove_y

# Add the font style and size
pdf.font "Helvetica"
pdf.font_size font_size

#start with EON Media Group
pdf.text_box @supplier_account.name, :at => [address_x,  pdf.cursor]
pdf.move_down lineheight_y
pdf.text_box @supplier_account.address, :at => [address_x,  pdf.cursor]
pdf.move_down lineheight_y
pdf.text_box @supplier_account.store_web, :at => [address_x,  pdf.cursor]
pdf.move_down lineheight_y

last_measured_y = pdf.cursor
pdf.move_cursor_to pdf.bounds.height

pdf.image logopath, :width => 215, :position => :right

pdf.move_cursor_to last_measured_y

# client address
pdf.move_down 65
last_measured_y = pdf.cursor

pdf.move_cursor_to last_measured_y

invoice_header_data = [ 
  ["Boleta #", @purchase.invoice_number],
  ["Fecha", @purchase.created_at.to_s],
  ["Total", number_to_currency(@purchase.paid_amount.to_s, precision: 0)]
]

pdf.table(invoice_header_data, :position => invoice_header_x, :width => 215) do
  style(row(0..1).columns(0..1), :padding => [1, 5, 1, 5], :borders => [])
  style(row(2), :background_color => 'e9e9e9', :border_color => 'dddddd', :font_style => :bold)
  style(column(1), :align => :right)
  style(row(2).columns(0), :borders => [:top, :left, :bottom])
  style(row(2).columns(1), :borders => [:top, :right, :bottom])
end

pdf.move_down 45

invoice_services_data = [ 
  ["Producto", "Talla", "Color", "Cantidad", "Total"]
]

@purchase.shopping_cart.shopping_cart_items.each_with_index do |sci, i|
	invoice_services_data[i+1] = [sci.product_stock_size.product.name, sci.product_stock_size.size.name, 
									sci.product_stock_size.color, sci.quantity, number_to_currency(sci.product_stock_size.product.price, precision: 0)]
end

pdf.table(invoice_services_data, :width => pdf.bounds.width) do
  style(row(1..-1).columns(0..-1), :padding => [4, 5, 4, 5], :borders => [:bottom], :border_color => 'dddddd')
  style(row(0), :background_color => 'e9e9e9', :border_color => 'dddddd', :font_style => :bold)
  style(row(0).columns(0..-1), :borders => [:top, :bottom])
  style(row(0).columns(0), :borders => [:top, :left, :bottom])
  style(row(0).columns(-1), :borders => [:top, :right, :bottom])
  style(row(-1), :border_width => 2)
  style(column(2..-1), :align => :right)
  style(columns(0), :width => 275)
  style(columns(1), :width => 75)
end

pdf.move_down 1

invoice_services_totals_data = Array.new

unless @purchase.discount.blank? or @purchase.discount == 0 or @purchase.discount_type.blank?
  invoice_services_totals_data[0] = ["Sub-Total", number_to_currency(@purchase.shopping_cart.price, precision: 0)]
  if @purchase.discount_type == 'absolute'
	invoice_services_totals_data[1] = ["Descuento", number_to_currency(@purchase.discount.to_s, precision: 0)]
  elsif @purchase.discount_type == 'percentage'
	invoice_services_totals_data[1] = ["Descuento", @purchase.discount.to_s+'%']
  end
  invoice_services_totals_data[2] = ["Total", number_to_currency(@purchase.paid_amount.to_s, precision: 0)]
else
  invoice_services_totals_data[0] = ["", ""] 
  invoice_services_totals_data[1] = ["", ""]
  invoice_services_totals_data[2] = ["Total", number_to_currency(@purchase.paid_amount.to_s, precision: 0)]
end

pdf.table(invoice_services_totals_data, :position => invoice_header_x, :width => 215) do
  style(row(0..1).columns(0..1), :padding => [1, 5, 1, 5], :borders => [])
  style(row(0), :font_style => :bold)
  style(row(2), :background_color => 'e9e9e9', :border_color => 'dddddd', :font_style => :bold)
  style(column(1), :align => :right)
  style(row(2).columns(0), :borders => [:top, :left, :bottom])
  style(row(2).columns(1), :borders => [:top, :right, :bottom])
end

pdf.move_down 25

pdf.text_box "Ticket de Cambio", :at => [400,  pdf.cursor]
pdf.move_down 10
pdf.image "#{Rails.root}/public/system/change_tickets/"+@purchase.supplier_account.name+'/'+@purchase.id.to_s+"_barcode.png", :width => 100, :at => [400,  pdf.cursor]

pdf.move_down 25

invoice_notes_data = [ 
  ["Gracias por tu compra"],
  ["Esperamos que vuelvas pronto!"],
  ["Un abrazo!"]
]

pdf.table(invoice_notes_data, :width => 275) do
  style(row(0..-1).columns(0..-1), :padding => [1, 0, 1, 0], :borders => [])
  style(row(0).columns(0), :font_style => :bold)
end