class RemoveNotNullFromUsersForEmailAndPassword < ActiveRecord::Migration
  def up
    change_column :users, :email, :string, null: true
    change_column :users, :encrypted_password, :string, null: true
  end
  def down
    change_column :users, :email, :string, null: false, default: ""
    change_column :users, :encrypted_password, :string, null: false, default: ""
  end
end
