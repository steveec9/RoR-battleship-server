class Game < ActiveRecord::Base

  attr_accessible :winner, :turn

  has_many :boards
  has_many :users, :through => :boards
  belongs_to :winner, :class_name => 'User'
  belongs_to :turn, :class_name => 'User'

  def self.join_game(user, board)
    if Board.valid?(board)
      if game = next_waiting_game
        game.add_user_to_game(user, board)
      else
        game = create_new_game(user, board)
      end
      game
    else
      nil
    end
  end

  def self.create_new_game(user, raw_board)
    game = Game.create(:turn => user)
    board = game.boards.create(:user => user)
    board.build_cells(raw_board)
    game
  end

  def self.next_waiting_game
    Board.group(:game_id).having('count(*) = 1').first.andand.game
  end

  def self.game_mapping
    Game.all.map do |game|
      [game, "#{game.users.first.name} VS. #{game.users.last.name}"]
    end
  end

  def add_user_to_game(user, raw_board)
    board = boards.create(:user => user)
    board.build_cells(raw_board)
  end

  def status(user)
    if winner
      if user == winner
        'won'
      else
        'lost'
      end
    else
      'playing'
    end
  end

  def turn?(user)
    users.count == 2 && turn.andand.id == user.andand.id
  end

  def fire(user, shot)
    result = { :hit => false, :sunk => nil }
    if board = opponent_board(user)
      result = board.fire(shot)
      if result[:hit] && board.all_ships_sunk?
        update_attributes(:winner => user)
      else
        update_attributes(:turn => opponent_user(user))
      end
    end
    result
  end

  def opponent_board(opponent)
    boards.where('users.id != ?', opponent.andand.id).includes(:user).first
  end

  def opponent_user(user)
    users.where('users.id != ?', user.andand.id).first
  end

  def purty_print
    puts "\n\n"
    boards.each do |board|
      puts "User: \e[33m#{board.user.name}\e[0m"
      board.purty_print
      puts "\n\n"
    end
  end
end
