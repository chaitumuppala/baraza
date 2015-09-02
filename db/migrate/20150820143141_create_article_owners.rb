class CreateArticleOwners < ActiveRecord::Migration
  def change
    create_table :article_owners do |t|
      t.references :article, index: true, foreign_key: true
      t.references :owner
      t.string :owner_type

      t.timestamps null: false
    end
  end
end
