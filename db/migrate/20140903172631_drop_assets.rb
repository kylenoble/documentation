class DropAssets < ActiveRecord::Migration
  def change
  	drop_table :asset
  end
end
