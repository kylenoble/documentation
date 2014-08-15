class CreateDocs < ActiveRecord::Migration
  def change
    create_table :docs do |t|
      t.string :title
      t.string :parent
      t.text :info

      t.timestamps
    end
  end
end
