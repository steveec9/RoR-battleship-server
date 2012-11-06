class CreateBoards < ActiveRecord::Migration
  def up
    create_table :boards do |t|
      t.integer :user_id
      t.integer :game_id
    end
  end

  def down
    drop_table :boards
  end
end
