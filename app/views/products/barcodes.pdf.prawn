pdf.define_grid(:columns => 5, :rows => 6, :gutter => 10)

i = 0
j = 0

@product.product_stock_sizes.each do |psz|
	psz.stock.times do
		pdf.grid([i,j], [i,j+1]).bounding_box do
			pdf.text @product.name[0..30]+(@product.name.length > 30 ? '...' : ''), size: 6
			pdf.move_down 1
			pdf.text psz.size.name+" - "+psz.color, size: 6
			pdf.move_down 1
			pdf.image "#{Rails.root}/public/system/barcodes/"+@product.supplier_account.name+"/"+psz.size.name+"_"+psz.color+"_"+@product.id.to_s+"_barcode.png"
			pdf.move_down 1
			pdf.text psz.barcode, size: 6
			pdf.move_down 20
			i = i + 1
			if i == 6
				j = j + 1
				i = 0
			end
			if j == 5
				j = 0
				pdf.start_new_page
			end
		end
	end
end