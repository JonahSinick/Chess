require './board.rb'

class Piece
  
  attr_accessor :board, :position, :color
  
  def initialize(board,position,color)
    @board = board
    @position = position
    @color = color
  end
  
  def possible_moves
  end
  
  def move(pos)
    if self.possible_moves.include?(pos)
      @board[@position] = nil
      @position = pos
      @board[pos] = self
    end
  end
  
  def in_board?(x, y)
    (0..7).include?(x) && (0..7).include?(y)
  end
  
  DIAGONALS =  [ [-1, -1], [-1, 1], [1, -1], [1, 1] ]
  HORVERTS = [ [0, -1], [0, 1], [-1, 0], [1, 0] ]
  
  def to_s
    if self.is_a?(Rook)
      "R"
    elsif self.is_a?(Bishop)
      "B"
    elsif self.is_a?(King)
      "K"
    end
  end

  def possible_moves
    positions = []
    move_dirs.each do |direction| 
      distance = 1
      while distance <= MAX_DISTANCE
        new_x = @position[0] + (direction[0] * distance) 
        new_y = @position[1] + (direction[1] * distance) 
        if !in_board?(new_x, new_y)
          break
        elsif @board[[new_x, new_y]].nil?
          positions << [new_x, new_y]
        elsif @board.diff_color?(self.position, [new_x, new_y])
          positions << [new_x, new_y]
          break
        else
          break
        end
        distance += 1
      end      
    end
    positions
  end
  
end


class SlidingPieces < Piece
  MAX_DISTANCE = 8
end

class Bishop < SlidingPieces
  def move_dirs
    DIAGONALS
  end
end

class Rook < SlidingPieces
  def move_dirs
    HORVERTS
  end
end

class Queen < SlidingPieces
  def move_dirs
    DIAGONALS + HORVERTS
  end
end

class SteppingPiece < Piece
  
  def possible_moves
    positions = []
    move_dirs.each do |direction|
      new_x = @position[0] + (direction[0]) 
      new_y = @position[1] + (direction[1]) 
      if !in_board?(new_x, new_y)
        break
      elsif @board[new_x, new_y].nil?
        positions << [new_x, new_y]
      elsif @board.diff_color(@position, [new_x, new_y])
        position << [new_x, new_y]
      end
    end
    positions
  end
  
end


class King < SteppingPiece
  def move_dirs
    DIAGONALS + HORVERTS
  end
  
end

class Knight < SteppingPiece
  def move_dirs
    [ [-2, -1], [2, -1], [-2, 1], [2, 1], [-1, -2], [1, -2], [-1, 2], [1, 2]]
  end
end


