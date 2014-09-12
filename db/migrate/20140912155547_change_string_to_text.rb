class ChangeStringToText < ActiveRecord::Migration
  def change
  	change_column :docs, :info, :text
  end
end
