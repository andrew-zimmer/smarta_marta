class CreateTableQuickPicks < ActiveRecord::Migration
  def change
    create_table :quick_picks do |t|
      t.integer :user_id
      t.string :station_name
      t.string :rail_line_name
      t.string :direction
      t.string :alias
    end
  end
end
