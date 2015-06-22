class AddAttachmentCoverImageToArticles < ActiveRecord::Migration
  def self.up
    change_table :articles do |t|
      t.attachment :cover_image
    end
  end

  def self.down
    remove_attachment :articles, :cover_image
  end
end
