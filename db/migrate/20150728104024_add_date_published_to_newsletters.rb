class AddDatePublishedToNewsletters < ActiveRecord::Migration
  def change
    add_column :newsletters, :date_published, :datetime
  end
end
