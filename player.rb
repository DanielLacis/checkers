require_relative './errors'

class HumanPlayer
   LETTER_HASH = { "a" => 0, "b" => 1, "c" => 2, "d" => 3, "e" => 4,
                   "f" => 5, "g" => 6, "h" => 7 }
  def initialize(color)
    @color = color
  end

  def get_move
    begin
      puts "enter move sequence: "
      start_str = gets.chomp
      moves = validate_input(start_str)
    rescue ParsingError => e
      puts e
      retry
    end

    moves.map { |str| string_convert(str) }
  end

  def validate_input(parse_str)
    moves = parse_str.split(/[, ]+/)
    moves.each do |move|
      raise ParsingError.new("Length is incorrect, use a0 format") if move.length != 2
      unless move[0].match(/[a-hA-H]/)
        raise ParsingError.new("first character is not a valid letter")
      end
      unless move[1].match(/[1-8]/)
        raise ParsingError.new("second character is not a valid number")
      end
    end
    moves
  end

  def string_convert(input_str)
    [8 - input_str[1].to_i, LETTER_HASH[input_str[0].downcase]]
  end
end
