class RenameChronicalTableToChronicle < ActiveRecord::Migration
  def change
    rename_table :user_chronicals, :user_chronicles

  end
end
