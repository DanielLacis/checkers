class Test
  def initialize
    @board = [[1,2,3], [4,5,6], [7,8,9]]
  end
  def [](pos)
    @board[pos[0]][pos[1]]
  end
end
