class AddDefaultStatusToArticle < ActiveRecord::Migration
  def up
    change_column :articles, :status, :string, default: "draft"
  end

  def down
    change_column :articles, :status, :string
  end
end
