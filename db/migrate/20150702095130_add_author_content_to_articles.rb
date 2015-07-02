class AddAuthorContentToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :author_content, :text
  end
end
