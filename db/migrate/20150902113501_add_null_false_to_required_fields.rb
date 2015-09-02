class AddNullFalseToRequiredFields < ActiveRecord::Migration
  def up
    change_column :articles, :title, :string, null: false
    change_column :articles, :summary, :text, null: false
    change_column :articles, :content, :text, null: false
    change_column :articles, :category_id, :integer, null: false
    change_column :authors, :full_name, :string, null: false
    change_column :newsletters, :name, :string, null: false
    change_column :users, :first_name, :string, null: false
    change_column :users, :last_name, :string, null: false
  end
  def down
    change_column :articles, :title, :string, null: true
    change_column :articles, :summary, :text, null: true
    change_column :articles, :content, :text, null: true
    change_column :articles, :category_id, :integer, null: true
    change_column :authors, :full_name, :string, null: true
    change_column :newsletters, :name, :string, null: true
    change_column :users, :first_name, :string, null: true
    change_column :users, :last_name, :string, null: true
  end
end
