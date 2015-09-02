class AddHomePageOrderToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :home_page_order, :integer
  end
end
