class RemoveArticleCategories < ActiveRecord::Migration
  def up
    drop_table :article_categories
  end

  def down
    create_table :article_categories do |t|
      t.references :article, index: true, foreign_key: true
      t.references :category, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
