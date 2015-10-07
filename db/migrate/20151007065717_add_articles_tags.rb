class AddArticlesTags < ActiveRecord::Migration
  def change
    create_table 'articles_tags', force: :cascade do |t|
      t.integer 'article_id', limit: 4
      t.integer 'tag_id',     limit: 4
      t.datetime 'created_at',           null: false
      t.datetime 'updated_at',           null: false
    end

    add_index 'articles_tags', ['article_id'], name: 'index_articles_tags_on_article_id', using: :btree
    add_index 'articles_tags', ['tag_id'], name: 'index_articles_tags_on_tag_id', using: :btree
  end
end
