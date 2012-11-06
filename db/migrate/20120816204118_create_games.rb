class CreateGames < ActiveRecord::Migration
  def up
    create_table :games do |t|
      t.integer :winner_id
      t.integer :turn_id
    end
  end

  def down
    drop_table :games
  end
end
