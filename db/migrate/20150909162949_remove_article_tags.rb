class RemoveArticleTags < ActiveRecord::Migration
  def change
    drop_table :articles_tags
  end
end
