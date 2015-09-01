class CreateNewsletters < ActiveRecord::Migration
  def change
    create_table :newsletters do |t|
      t.string :name, null: false
      t.string :status, default: 'draft'
      t.datetime :date_published

      t.timestamps null: false
    end
  end
end
