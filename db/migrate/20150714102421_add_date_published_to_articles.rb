class AddDatePublishedToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :date_published, :datetime
  end
end
