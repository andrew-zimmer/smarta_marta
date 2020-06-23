class CreateTableUserHistory < ActiveRecord::Migration
  def change
    create_table :user_histories do |t|
      t.datetime :date
      t.string :station_name
      t.string :direction
      t.string :rail_line_name
      t.integer :user_id
    end
  end
end
