class AddAdminKeyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin_key, :string
  end
end
