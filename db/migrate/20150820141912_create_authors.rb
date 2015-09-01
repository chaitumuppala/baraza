class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.string :full_name, null: false
      t.string :email, null: false

      t.timestamps null: false
    end
  end
end
