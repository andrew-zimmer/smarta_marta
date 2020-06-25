class RollbackPrevious < ActiveRecord::Migration
  def change
    remove_column :user_chronicles, :created_at, :timestamps
    remove_column :user_chronicles, :updated_at, :timestamps
  end
end
