require "./piece.rb"

class Bishop < Piece
  @max_distance = 8
  def move_dirs
    DIAGONALS
  end
  def to_s
    "B"
  end
end

class Rook < Piece
  @max_distance = 8
  def move_dirs
    HORVERTS
  end
  
  def to_s
    "R"
  end
end

class Queen < Piece
  @max_distance = 8
  def move_dirs
    DIAGONALS + HORVERTS
  end
  
  def to_s
    "Q"
  end
end


class King < Piece
  @max_distance = 1
  def move_dirs
    DIAGONALS + HORVERTS
  end
  
  def to_s
    "K"
  end
  
end

class Knight < Piece
  @max_distance = 1  
  def move_dirs
    [ [-2, -1], [2, -1], [-2, 1], [2, 1], [-1, -2], [1, -2], [-1, 2], [1, 2]]
  end
  
  def to_s
    "N"
  end
end
