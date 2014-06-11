require './board.rb'
require 'debugger'
require './pieces.rb'

class Piece
  
  attr_accessor :board, :position, :color
  DIAGONALS =  [ [-1, -1], [-1, 1], [1, -1], [1, 1] ]
  HORVERTS = [ [0, -1], [0, 1], [-1, 0], [1, 0] ]
  

  def initialize(board, position, color, window)
    @board = board
    @position = position
    @color = color
    @image =  Gosu::Image.new(window, "nil.png",false) unless window.nil?
    @value = nil
  end
  
  def self.max_distance
    @max_distance
  end
  
  def move(pos)
    @board[@position] = nil
    @position = pos
    @board[pos] = self
  end
  
  def in_board?(x, y)
    (0..7).include?(x) && (0..7).include?(y)
  end

  def dup(board)
    self.class.new(board, @position, @color, board.window)
  end
  
  def possible_moves
    positions = []
    move_dirs.each do |direction| 
      distance = 1
      while distance <= self.class.max_distance
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
  
  def valid_moves
    possible_moves.select do |pos|
      is_valid?(pos)
    end
  end  
  
  def is_valid?(pos)
    test_board = @board.dup
    duplicate_piece = test_board[@position]
    duplicate_piece.move(pos)
    !test_board.in_check?(@color)
  end
  
  def draw
    @image.draw(pix_x, pix_y, 1)
  end
  
  def pix_x
    @position[1] * 80 + 8
  end
  
  def pix_y
    @position[0] * 80 + 8
  end
  

end



