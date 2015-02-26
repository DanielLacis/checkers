class Board
  attr_reader :board

  def initialize
    generate_board
    populate_board
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
          self[pos] = black_piece(pos) if (row_idx + col_idx) % 2 == 1
        end
      elsif row_idx > 4
        (0...board[0].length).each do |col_idx|
          pos = [row_idx, col_idx]
          self[pos] = red_piece(pos) if (row_idx + col_idx) % 2 == 1
        end
      end
    end
    true
  end

  def black_piece(pos)
    Piece.new({ position: pos, color: :black, board: self })
  end

  def red_piece(pos)
    Piece.new({ position: pos, color: :red, board: self })
  end

  def render
    render_string = ""
    board.each_with_index do |row, row_idx|
      row.each_index do |col_idx|
        pos = [row_idx, col_idx]
        render_string << symbol_and_color(pos)
      end
      render_string << "\n"
    end
    render_string
  end

  def symbol_and_color(pos)
    colored_string = ""
    bg_color = determine_bg_color(pos)
    if self[pos].nil?
      "   ".colorize(background: bg_color)
    else
      "#{self[pos].symbol}  ".colorize(background: bg_color)
    end
  end

  def determine_bg_color(pos)
    if (pos[0] + pos[1]) % 2 == 0
      bg_color = :white
    else
      bg_color = :green
    end
  end

  def display
    puts render
  end
end
