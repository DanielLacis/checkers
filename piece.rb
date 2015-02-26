class Piece
  attr_reader :board, :position, :kinged, :move_dirs, :color, :symbol
  def self.sum_pos(pos, delta)
    [pos[0] + delta[0], pos[1] + delta[1]]
  end

  def initialize(options = {})
    defaults = { position: nil, kinged: false, color: nil, move_dirs: [], board: nil, jump_dirs: [] }
    options = defaults.merge(options)
    @kinged = options[:kinged]
    @position = options[:position] # [row, col]
    @color = options[:color] # red gets bottom
    @board = options[:board]
    set_move_dirs(options[:move_dirs])
    set_jump_dirs(options[:jump_dirs])
    set_symbol
  end

  def set_move_dirs(options_move_dirs)
    if options_move_dirs.empty?
      @move_dirs = (color == :red ? [[-1, -1], [-1, 1]] : [[1, 1], [1, -1]])
    else
      @move_dirs = options_move_dirs
    end
  end

  def set_jump_dirs(options_jump_dirs)
    if options_jump_dirs.empty?
      @jump_dirs = (color == :red ? [[-2, -2], [-2, 2]] : [[2, 2], [2, -2]])
    else
      @jump_dirs = options_jump_dirs
    end
  end

  def kinged?
    @kinged
  end

  def perform_slide(end_pos)
    if validate_slide(end_pos)
      board[end_pos] = self
      board[position] = nil
      @position = end_pos
      check_king
      return true
    end

    false # would already return this when if evaluates false
  end

  def possible_slides
    move_dirs.map { |dir| Piece.sum_pos(position, dir) }
  end

  def possible_jumps
    jump_dirs.map { |dir| Piece.sum_pos(position, dir) }
  end


  def check_king
    unless kinged
      if position[0] == 0 || position[0] == 7 # first/last row of board
        @kinged = true
        @move_dirs += (color == :red ? [[1, 1], [1, -1]] : [[-1, -1], [-1, 1]])
        @jump_dirs += (color == :red ? [[2, 2], [2, -2]] : [[-2, -2], [-2, 2]])
      end
    end
  end

  def validate_slide(end_pos)
    return true if board[end_pos].empty? && possible_slides.include?(end_pos)
    false
  end

  def set_symbol
    if color == :red
      # @symbol = "#{["26C4".hex].pack("U")} ".colorize(:red)
      @symbol = ["26C4".hex].pack("U").colorize(:red)
    else
      @symbol = ["2693".hex].pack("U").colorize(:black)
    end
  end
end
