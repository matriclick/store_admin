class ProductImage < ActiveRecord::Base
  belongs_to :product
  
  has_attached_file :photo, :styles => { :main => "300x",	:side => "70x",	:index_dress => "190x", :tiny => "40x" }

	validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif', 'image/bmp', 'image/x-png', 'image/pjpeg']
	validates_attachment_size :photo, :less_than => 2.megabytes
	
end
