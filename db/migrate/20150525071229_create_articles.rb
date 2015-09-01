class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title, null: false
      t.text :content, null: false
      t.integer :creator_id
      t.boolean :top_story
      t.references :newsletter
      t.integer :position_in_newsletter
      t.string :status, default: 'draft'
      t.text :author_content
      t.text :summary, null: false
      t.integer :home_page_order
      t.datetime :date_published
      t.references :category, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end

    add_index :articles, [:creator_id], name: :index_articles_on_creator_id, using: :btree
  end
end
