class ChangeFromUserIdToCreatorId < ActiveRecord::Migration
  def change
    rename_column :articles, :user_id, :creator_id
  end
end
