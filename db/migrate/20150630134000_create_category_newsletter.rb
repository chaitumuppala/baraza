class CreateCategoryNewsletter < ActiveRecord::Migration
  def change
    create_table :category_newsletters do |t|
      t.references  :category, index: true, foreign_key: true
      t.references  :newsletter, index: true, foreign_key: true
      t.integer     :position_in_newsletter
    end
  end
end
