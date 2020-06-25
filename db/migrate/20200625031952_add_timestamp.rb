class AddTimestamp < ActiveRecord::Migration
  def change
    change_table(:user_chronicles) { |t| t.timestamps }
  end
end
