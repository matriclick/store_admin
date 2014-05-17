class CreateProviders < ActiveRecord::Migration
  def change
    create_table :providers do |t|
      t.string :name
      t.text :address
      t.string :country

      t.timestamps
    end
  end
end
