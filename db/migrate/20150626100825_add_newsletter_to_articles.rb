class AddNewsletterToArticles < ActiveRecord::Migration
  def change
    add_reference :articles, :newsletter
  end
end
