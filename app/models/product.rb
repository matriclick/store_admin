# encoding: UTF-8
require 'roo'
class Product < ActiveRecord::Base  
  has_and_belongs_to_many :product_categories
  has_many :product_images, :dependent => :destroy
	has_many :product_stock_sizes, :dependent => :destroy
	has_many :sizes, :through => :product_stock_sizes
  belongs_to :supplier_account
  
  accepts_nested_attributes_for :product_images, :allow_destroy => true
	accepts_nested_attributes_for :product_stock_sizes, :allow_destroy => true
	
	def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      Product.create! row.to_hash
    end
  end
  
  def self.import(file, col_sep, supplier_account)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]    
      if supplier_account.nil?
        return false
      end
      provider = Provider.where('name = ? and supplier_account_id = ?', row["Proveedor"], supplier_account.id).first || Provider.create(:name => row["Proveedor"], :address => row["Dirección Proveedor"], supplier_account_id: supplier_account.id)
      puts provider.name
      product = Product.find_by_name(row["Nombre Producto"]) || Product.create(:name => row["Nombre Producto"], :internal_code => row["Código Producto"], price: row["Precio"], supplier_account_id: supplier_account.id)
      puts product.name
      unless row["Talla"].blank?
        size = Size.find_by_name(row["Talla"]) || Size.create(:name => row["Talla"], supplier_account_id: supplier_account.id)
      else
        size = Size.find_by_name("Estándar") || Size.create(:name => "Estándar", supplier_account_id: supplier_account.id)
      end
      puts size.name
      if row["Color"].blank?
          row["Color"] = ''
      end
      puts row["Color"]
    
      product_stock_sizes = ProductStockSize.where('size_id = ? and color = ? and product_id = ?', size.id, row["Color"], product.id)
      if product_stock_sizes.size > 0
        product_stock_size = product_stock_sizes.first
        product_stock_size.update_attribute :stock, product_stock_size.stock + row['Stock']
      else
        product_stock_size = ProductStockSize.create(size_id: size.id, color: row['Color'], product_id: product.id, stock: row['Stock'])
      end
      puts product_stock_size.color
      supply_purchase = SupplyPurchase.create(total_paid: row['Costo por Unidad']*row['Unidades Compradas'], currency_id: 1, provider_id: provider.id, comments: 'Generada automáticamente por una carga desde archivo .csv')
      supply_purchase_product_size = SupplyPurchaseProductSize.create(unit_cost: row['Costo por Unidad'], currency_id: 1, supply_purchase_id: supply_purchase.id, product_stock_size_id: product_stock_size.id)
      supply_purchase_product_size.update_column :quantity, row['Unidades Compradas']
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when '.csv' then Roo::Csv.new(file.path, nil, :ignore)
    when '.xls' then Roo::Excel.new(file.path, nil, :ignore)
    when '.xlsx' then Roo::Excelx.new(file.path, nil, :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end
  
end
