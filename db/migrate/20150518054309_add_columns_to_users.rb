class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :year_of_birth, :integer
    add_column :users, :country, :string
    add_column :users, :gender, :string
  end
end
