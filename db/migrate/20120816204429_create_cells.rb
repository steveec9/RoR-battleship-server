class CreateCells < ActiveRecord::Migration
  def up
    create_table :cells do |t|
      t.integer :ship
      t.boolean :hit, :default => nil
      t.boolean :miss, :default => nil
      t.string :location
      t.integer :board_id
    end
  end

  def down
    drop_table :cells
  end
end
