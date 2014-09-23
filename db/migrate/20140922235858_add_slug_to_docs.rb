class AddSlugToDocs < ActiveRecord::Migration
  def change
    add_column :docs, :slug, :string
    add_index :docs, :slug
  end
end

