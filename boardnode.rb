require './board.rb'

class BoardNode
  
  
  attr_accessor :board, :piece, :position, :color
  
  def 
  
  def initialize(board,piece,position, color)
    @board = board
    @piece = piece
    @position = position
    @color = color
  end
  
  def other_color
    @color == :white ? :black : :white
  end
  
  def children
    new_board = self.board.dup
    duplicate_piece = new_board.board[piece.position]
    duplicate_piece.move(pos)

    new_board.possible_pieces_with_moves(other_color).each do |piece, moves|
      moves.each do |move|
        
        
      end
    end
    children
  end
  
  def score(piece, posn)
    if n == 1
      score(n)
  

end