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

invoice_services_data = [ 
  ["Valor", "Válido Hasta", "Código"],
  [number_to_currency(@gift_card.amount, precision: 0), l(@gift_card.valid_until.in_time_zone(@time_zone), format: :long), @gift_card.barcode]
]

pdf.table(invoice_services_data, :width => pdf.bounds.width) do
  style(row(1..-1).columns(0..-1), :padding => [4, 5, 4, 5], :borders => [:bottom], :border_color => 'dddddd')
  style(row(0), :background_color => 'e9e9e9', :border_color => 'dddddd', :font_style => :bold)
  style(row(0).columns(0..-1), :borders => [:top, :bottom])
  style(row(0).columns(0), :borders => [:top, :left, :bottom])
  style(row(0).columns(-1), :borders => [:top, :right, :bottom])
  style(row(-1), :border_width => 2)
  style(column(2..-1), :align => :right)
  style(columns(0), :width => 200)
  style(columns(1), :width => 200)
end

pdf.move_down 10
pdf.image "#{Rails.root}/public/system/gift_cards/"+@gift_card.supplier_account.name+'/'+@gift_card.id.to_s+"_barcode.png", :width => 100, :at => [400,  pdf.cursor]

pdf.move_down 25

invoice_notes_data = [ 
  ["Disfruta de esta GiftCard"],
  ["Esperamos que verte pronto!"],
  ["Un abrazo!"]
]

pdf.table(invoice_notes_data, :width => 275) do
  style(row(0..-1).columns(0..-1), :padding => [1, 0, 1, 0], :borders => [])
  style(row(0).columns(0), :font_style => :bold)
end