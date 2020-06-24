class ChangeUserHistoryTableName < ActiveRecord::Migration
  def change
    rename_table :user_history, :user_chronicals
  end
end
