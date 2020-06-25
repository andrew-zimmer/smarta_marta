class DeleteDateColumnAddCreatedAtUpdatedAtColumnsForUserChronicles < ActiveRecord::Migration
  def change
    remove_column :user_chronicles, :date
    add_column :user_chronicles, :created_at, :timestamps
    add_column :user_chronicles, :updated_at, :timestamps
  end
end
