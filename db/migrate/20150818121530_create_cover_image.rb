class CreateCoverImage < ActiveRecord::Migration
  def up
    create_table :cover_images do |t|
      t.attachment :cover_photo
      t.references :article, index: true, foreign_key: true
    end
  end

  def down
    drop_table :cover_images
  end
end