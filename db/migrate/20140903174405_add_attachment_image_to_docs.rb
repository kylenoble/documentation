class AddAttachmentImageToDocs < ActiveRecord::Migration
  def self.up
    change_table :docs do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :docs, :image
  end
end
