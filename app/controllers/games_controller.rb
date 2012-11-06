class GamesController < ApplicationController
  before_filter :set_game_mapping, :only => [:index, :show]

  def index
  end

  def show
    @game = Game.find_by_id(params[:id])
    @board1, @board2 = @game.boards.map(&:encode)
  end

  def boards
    @board1, @board2 = Game.find_by_id(params[:id]).boards.map(&:encode)
    render :partial => 'partials/board'
  end

  def join
    if params[:user] && params[:board]
      user = User.find_or_create_by_name(params[:user])
      game = Game.join_game(user, JSON.parse(params[:board]))
      if game
        render :json => { :game_id => game.id }
      else
        error
      end
    else
      error
    end
  end

  def status
    if params[:user] && params[:game_id]
      user = User.find_by_name(params[:user])
      game = Game.find_by_id(params[:game_id])
      if game && user
        render :json => { :game_status => game.status(user), :my_turn => game.turn?(user) } # status => 'playing', 'won', 'lost'
      else
        error
      end
    else
      error
    end
  end

  def fire
    if params[:user] && params[:game_id] && params[:shot]
      user = User.find_by_name(params[:user])
      game = Game.find_by_id(params[:game_id])
      shot = params[:shot].capitalize
      if game && user && game.turn?(user) && (shot =~ /[A-J]\d/)
        result = game.fire(user, params[:shot])
        game.purty_print
        render :json => { :hit => result[:hit], :sunk => result[:sunk] }
      else
        error
      end
    else
      error
    end
  end

  private

  def set_game_mapping
    @games = Game.game_mapping
  end

end
