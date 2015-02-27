class Piece
  RED_MOVE_DIRS = [[-1, -1], [-1, 1]]
  BLACK_MOVE_DIRS = [[1, 1], [1, -1]]
  KING_MOVE_DIRS = [[-1, -1], [-1, 1], [1, 1], [1, -1]]
  attr_reader :board, :position, :kinged, :color, :symbol
  def self.sum_pos(pos, delta)
    [pos[0] + delta[0], pos[1] + delta[1]]
  end

  def initialize(options = {})
    defaults = { position: nil, kinged: false, color: nil, board: nil, jump_dirs: [] }
    options = defaults.merge(options)
    @kinged = options[:kinged]
    @position = options[:position] # [row, col]
    @color = options[:color] # red gets bottom
    @board = options[:board]
    set_symbol
  end

  def kinged?
    @kinged
  end

  def make_move(end_pos)
    if possible_slides.include?(end_pos)
      perform_slide(end_pos)
    elsif possible_jumps.include?(end_pos)
      perform_jump(end_pos)
    else
      raise PieceError.new("The chosen piece cannot make this move")
    end
    true
  end

  def perform_slide(end_pos)
    unless validate_slide(end_pos)
      raise PieceError.new("This slide is not valid")
    end
    execute_slide(end_pos)

    false # would already return this when if evaluates false
  end

  def perform_jump(end_pos)
    dir = determine_dir(end_pos)

    unless dir
      raise PieceError.new("this jump is not valid (dir error)")
    end
    unless validate_jump(end_pos, dir)
      raise PieceError.new("This jump is not valid")
    end
    return execute_jump(end_pos, dir)

    false # would already return this when if evaluates false
  end

  def execute_slide(end_pos)
    board[end_pos] = self
    board[position] = nil
    @position = end_pos
    check_king
    true
  end

  def execute_jump(end_pos, dir)
    jumped_over_pos = Piece.sum_pos(position, dir)
    board[end_pos] = self
    board[jumped_over_pos] = nil
    board[position] = nil
    @position = end_pos
    check_king
    true
  end

  def determine_dir(end_pos)
    move_dirs.each do |dir|
      return dir if Piece.sum_pos(Piece.sum_pos(position, dir), dir) == end_pos
    end

    false
  end

  def possible_slides
    move_dirs.map { |dir| Piece.sum_pos(position, dir) }
  end

  def possible_jumps
    move_dirs.map { |dir| Piece.sum_pos(Piece.sum_pos(position, dir), dir) }
  end


  def check_king
    unless kinged
      if position[0] == 0 || position[0] == 7 # first/last row of board
        @kinged = true
        king_symbol
      end
    end
  end

  def validate_slide(end_pos)
    return false unless end_pos[0].between?(0,7) && end_pos[1].between?(0,7)
    return true if board[end_pos].nil? && possible_slides.include?(end_pos)
    false
  end

  def validate_jump(end_pos, dir)
    return false unless end_pos[0].between?(0,7) && end_pos[1].between?(0,7)
    intermediate_pos = Piece.sum_pos(position, dir)
    return true if jump_between_occupied?(intermediate_pos) &&
                   jump_end_empty?(end_pos)

    false
  end

  def jump_end_empty?(end_pos)
    board[end_pos].nil? && possible_jumps.include?(end_pos)
  end

  def jump_between_occupied?(intermediate_pos)
    board[intermediate_pos].is_a?(Piece) && board[intermediate_pos].color != color
  end

  def move_dirs
    return KING_MOVE_DIRS if kinged?
    color == :red ? RED_MOVE_DIRS : BLACK_MOVE_DIRS
  end

  def set_symbol
    if color == :red
      @symbol = "⛄" # coffee
    else
      @symbol = "☕" # snowman
    end
  end

  def king_symbol
    if color == :red
      @symbol = "⛅" # sun and clouds
    else
      @symbol = "☢".colorize(:yellow) # coffee
    end
  end
end
