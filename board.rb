require './piece.rb'
require 'debugger'

class Board
  attr_accessor :board, :king_pos
  def initialize
    @board = Array.new(8) {Array.new(8)}
    place_pieces
    @king_pos = {white: [7,4], black: [0, 4]}
  end
  
  def place_pieces
    @board[0][0] = Rook.new(self, [0,0], :black)
    @board[7][7] = Rook.new(self, [7,7], :white)
    @board
  end
  
  def []=(pos, obj)
    row, col = pos
    @board[row][col] = obj
  end
  
  def [](pos)
    row, col = pos
    @board[row][col]
  end
  
  def in_check?(color)
    board.flatten.each do |piece|
      if piece.nil? || piece.color == color
        next
      end
      piece.possible_moves.each do |pos|
        #debugger
        return true if pos == @king_pos[color]
      end
    end
    false
  end
  
  def same_color(pos1, pos2)
    self[pos1].color == self[pos2].color    
  end
  
  def diff_color(pos1, pos2)
    !same_color(pos1, pos2)
  end
  
end