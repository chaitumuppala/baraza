class AddTopStoryToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :top_story, :boolean
  end
end
