class CreateCoverImage < ActiveRecord::Migration
  def change
    create_table :cover_images do |t|
      t.attachment  :cover_photo
      t.references  :article, index: true, foreign_key: true
      t.boolean     :preview_image, default: false
    end
  end
end
