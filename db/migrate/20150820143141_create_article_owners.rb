class CreateArticleOwners < ActiveRecord::Migration
  def change
    create_table :article_owners do |t|
      t.references :article, index: true, foreign_key: true
      t.references :owner
      t.string :owner_type

      t.timestamps null: false
    end

    # add_index :article_owners, [:['owner_id', 'owner_type']]
    # add_index :article_owners, [:administrator_id, :article_id]
    # add_index :article_owners, [:article_id, :user_id]
    # add_index :article_owners, [:article_id, :author_id]
    # add_index :article_owners, [:article_id, :registered_user_id]
  end
end
