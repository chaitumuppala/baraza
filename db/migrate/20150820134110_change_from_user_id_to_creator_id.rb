class ChangeFromUserIdToCreatorId < ActiveRecord::Migration
  def up
    remove_foreign_key :articles, :user
    rename_column :articles, :user_id, :creator_id
  end

  def down
    rename_column :articles, :creator_id, :user_id
    add_foreign_key :articles, :user
  end
end
