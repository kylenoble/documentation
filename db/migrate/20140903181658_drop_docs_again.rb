class DropDocsAgain < ActiveRecord::Migration
  def change
  	drop_table :docs
  end
end
