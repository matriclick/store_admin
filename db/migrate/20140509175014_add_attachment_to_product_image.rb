class AddAttachmentToProductImage < ActiveRecord::Migration
  def self.up
    add_attachment :product_images, :photo
  end

  def self.down
    remove_attachment :product_images, :photo
  end
end
