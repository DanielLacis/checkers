require_relative './board'
require_relative './player'

require 'colorize'
class Game
  attr_reader :game_board, :players, :turn
  def initialize
    @game_board = Board.new
    @players = { red: HumanPlayer.new(:red), black: HumanPlayer.new(:black) }
    @turn = :red
  end

  def play
    until won?
      game_board.display
      take_turn
      swap_turn
    end
    game_board.display
    puts "The #{other_turn} player has won the game!"

  end

  def take_turn
    begin
      move_sequence = players[turn].get_move
      send_move(move_sequence, turn)
    rescue PieceError => e
      game_board.display
      puts e
      retry
    end

    true
  end

  def send_move(move_sequence, turn)
    start_pos = move_sequence.first
    raise PieceError.new("piece not present") if game_board[start_pos].nil?
    if game_board[start_pos].color != turn
      raise PieceError.new("wrong color piece")
    end
    game_board[start_pos].perform_moves!(move_sequence)
  end

  def won?
    return true if game_board.color_pieces(turn).length == 0
  end

  def swap_turn
    @turn = other_turn
  end

  def other_turn
    (@turn == :red ? :black : :red)
  end
end
