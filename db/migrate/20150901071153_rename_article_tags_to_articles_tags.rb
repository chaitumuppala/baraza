class RenameArticleTagsToArticlesTags < ActiveRecord::Migration
  def change
    rename_table :article_tags, :articles_tags
  end
end
