class AddPreviewImageToCoverImage < ActiveRecord::Migration
  def change
    add_column :cover_images, :preview_image, :boolean, default: false
  end
end
