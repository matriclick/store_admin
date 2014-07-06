# encoding: UTF-8
require 'roo'
require "uri"
require "net/http"
require 'net/http/post/multipart'

class Product < ActiveRecord::Base
  #after_save :send_to_marketplace
  
  has_and_belongs_to_many :product_categories
  has_many :product_images, :dependent => :destroy
	has_many :product_stock_sizes, :dependent => :destroy
	has_many :sizes, :through => :product_stock_sizes
  belongs_to :supplier_account
  
  accepts_nested_attributes_for :product_images, :allow_destroy => true
	accepts_nested_attributes_for :product_stock_sizes, :allow_destroy => true
	
  validates :name, presence: true, :uniqueness => {:scope => :supplier_account_id}
  validates :price, presence: true
	
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
      unless row["Proveedor"].blank?
        provider = Provider.where('name = ? and supplier_account_id = ?', row["Proveedor"], supplier_account.id).first || Provider.create(:name => row["Proveedor"], :address => row["Dirección Proveedor"], supplier_account_id: supplier_account.id)
      else
        provider = Provider.find_by_name('Sin Proveedor')
      end
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
        product_stock_size = ProductStockSize.create(size_id: size.id, stock: row['Stock'], color: row['Color'], product_id: product.id, internal_code: row['Código Producto'])
      end
      puts product_stock_size.color
      supply_purchase = SupplyPurchase.new(provider_id: provider.id, comments: 'Generada automáticamente por una carga desde archivo .csv')
      supply_purchase.save!(:validate => false)
      supply_purchase_product_size = SupplyPurchaseProductSize.create(quantity: row['Unidades Compradas'], unit_cost: row['Costo por Unidad'], currency_id: 1, supply_purchase_id: supply_purchase.id, product_stock_size_barcode: product_stock_size.barcode, update_stock: false)
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
    
  def send_to_marketplace
    #Define Store ID
    store_id = 1
    params = { :'product[store_id]' => store_id.to_s, :'product[name]' => "Ruby_9", :'product[price]' => 10000 }
    self.product_images.each do |image|
      params.merge!({ 'product[product_images_attributes]['+image.id.to_s+'][photo]' => UploadIO.new(File.new("#{Rails.root}/public"+image.photo.url(:original, timestamp: false)), image.photo_content_type, image.photo_file_name) })
    end
    self.product_stock_sizes.each do |pss|
      params.merge!({ 'product[product_stock_sizes_attributes]['+pss.id.to_s+'][stock]' =>  pss.stock, 'product[product_stock_sizes_attributes]['+pss.id.to_s+'][size]' => pss.size.name, 'product[product_stock_sizes_attributes]['+pss.id.to_s+'][color]' => pss.color })
    end
  
    url = URI.parse('http://localhost:3000/stores/'+store_id.to_s+'/products')
    req = Net::HTTP::Post::Multipart.new(url.path, params)
    res = Net::HTTP.start(url.host, url.port) do |http|
      http.request(req)
    end
    
  end
end
