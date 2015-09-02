class AddPositionInNewsletterToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :position_in_newsletter, :integer
  end
end
