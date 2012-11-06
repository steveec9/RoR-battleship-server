class Board < ActiveRecord::Base
  attr_accessible :user

  belongs_to :user
  belongs_to :game
  has_many :cells

  def self.valid?(board)
    true
  end

  def build_cells(raw_board)
    raw_board.zip(1..10).each do |row, i|
      row.zip('A'..'J').each do |cell, j|
        ship = (cell != '' ? cell : nil)
        cells.create(:ship => ship, :location => "#{j}#{i}")
      end
    end
  end

  def fire(shot)
    cell = cells.where(:location => shot).first
    sunk = nil
    if hit = cell.shoot
      sunk = (ship_sunk?(cell, cell.ship) ? cell.ship : nil)
    end

    { :hit => hit, :sunk => sunk }
  end

  def ship_sunk?(cell, ship_size)
    idx = cell_index(cell)
    hits = cells.order(:id).map { |c| c.hit ? c.ship : nil }
    horizontally_sunk?(hits, idx, ship_size) || vertically_sunk?(hits, idx, ship_size)
  end

  def all_ships_sunk?
    cells.where(:hit => true).count == 17
  end

  def purty_print
    idx = 0
    cells.order(:id).each do |cell|
      if idx != 0 && idx % 10 == 0
        puts ""
      end
      if idx % 10 == 0
        puts ("\e[36m-----------------------------------------\e[0m")
        print "|"
      end
      print(cell.hit.nil? ? (cell.ship ? "\e[37m #{cell.ship} \e[0m" : "   ") : (cell.hit ? "\e[41m H \e[0m" : "\e[44m M \e[0m"))
      print "|"
      idx += 1
    end
    puts ("\n\e[36m-----------------------------------------\e[0m")
  end

  def encode
    board = []
    cells.order(:id).each_slice(10) do |cell_row|
      board << cell_row.map do |cell|
        cell.hit.nil? ? (cell.ship ? cell.ship : "x") : (cell.hit ? "H" : "M")
      end
    end
    { :username => user.name, :board => board }
  end

  private

  def cell_index(cell)
    (cell.location[1..-1].to_i - 1) * 10 + ('A'..'J').to_a.index(cell.location.first)
  end

  def horizontally_sunk?(hits, idx, ship_size)
    (left_hit_count(hits, idx, ship_size) + right_hit_count(hits, idx, ship_size) + 1) >= ship_size
  end

  def left_hit_count(hits, idx, ship_size)
    count = 0
    (1 .. [idx % 10, ship_size - 1].min).each do |i|
      if hits[idx - i] == ship_size
        count += 1
      else
        break
      end
    end
    count
  end

  def right_hit_count(hits, idx, ship_size)
    count = 0
    (1 .. [10 - (idx % 10) - 1, ship_size - 1].min).each do |i|
      if hits[idx + i] == ship_size
        count += 1
      else
        break
      end
    end
    count
  end

  def vertically_sunk?(hits, idx, ship_size)
    (top_hit_count(hits, idx, ship_size) + bottom_hit_count(hits, idx, ship_size) + 1) >= ship_size
  end

  def top_hit_count(hits, idx, ship_size)
    count = 0
    (1 .. [idx / 10, ship_size - 1].min).each do |i|
      if hits[idx - (i * 10)] == ship_size
        count += 1
      else
        break
      end
    end
    count
  end

  def bottom_hit_count(hits, idx, ship_size)
    count = 0
    (1 .. [10 - (idx / 10) - 1, ship_size - 1].min).each do |i|
      if hits[idx + (i * 10)] == ship_size
        count += 1
      else
        break
      end
    end
    count
  end

end
