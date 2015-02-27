require_relative './piece'
require 'byebug'

class Board
  ROW_NUMBERS = (1..8).to_a.reverse
  COLUMN_LETTERS = ("a".."h").to_a
  attr_reader :board, :row_numbers, :column_letters

  def initialize(populate = true)
    generate_board
    populate_board if populate
  end

  def generate_board
    @board = Array.new(8) { Array.new(8) }
  end

  def [](pos) # pos is [row, col]
    @board[pos[0]][pos[1]]
  end
  #
  def []=(pos, piece)
    @board[pos[0]][pos[1]] = piece
  end

  def populate_board
    (0...board.length).each do |row_idx|
      if row_idx < 3
        (0...board[0].length).each do |col_idx|
          pos = [row_idx, col_idx]
          self[pos] = black_piece(pos) if (row_idx + col_idx).odd?
        end
      elsif row_idx > 4
        (0...board[0].length).each do |col_idx|
          pos = [row_idx, col_idx]
          self[pos] = red_piece(pos) if (row_idx + col_idx).odd?
        end
      end
    end
    # # for king symbols
    # self[[1,0]] = red_piece([1,0])
    # self[[6,1]] = black_piece([6,1])

    # # for winning
    # self[[4,1]] = red_piece([4,1])
    # self[[3,2]] = black_piece([3,2])
    true
  end

  def black_piece(pos, kinged = false)
    Piece.new({ position: pos, color: :black, board: self })
  end

  def red_piece(pos, kinged = false)
    Piece.new({ position: pos, color: :red, board: self })
  end

  def render
    render_string = ""
    render_string << render_letters
    board.each_with_index do |row, row_idx|
      render_string << "#{ROW_NUMBERS[row_idx]} "
      row.each_index do |col_idx|
        pos = [row_idx, col_idx]
        render_string << symbol_and_color(pos)
      end
      render_string << " #{ROW_NUMBERS[row_idx]}\n"
    end
    render_string << render_letters
    render_string
  end

  def render_letters
    letter_string = "  "
    COLUMN_LETTERS.each { |letter| letter_string << " #{letter}  "}
    letter_string << "\n"
  end

  def symbol_and_color(pos)
    colored_string = ""
    bg_color = determine_bg_color(pos)
    if self[pos].nil?
      "    ".colorize(background: bg_color)
    else
      " #{self[pos].symbol}  ".colorize(background: bg_color)
    end
  end

  def determine_bg_color(pos)
    if (pos[0] + pos[1]).even?
      bg_color = :black
    else
      bg_color = :red
    end
  end

  def color_pieces(color)
    board.flatten.compact.select { |piece| piece.color == color }
  end

  def pieces
    board.flatten.compact
  end

  def display
    puts render
  end

  def dup
    new_board = Board.new(false)
    pieces.each do |piece|
      new_board[piece.position] = piece.dup
      new_board[piece.position].board = new_board
    end
    new_board
  end
end
