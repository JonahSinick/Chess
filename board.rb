load './piece.rb'
require 'debugger'

class Board
  attr_accessor :board
  def initialize
    @board = Array.new(8) { Array.new(8) }
    place_pieces
  end
  
  def place_pieces
    @board[0][0] = Rook.new(self, [0,0], :black)
    @board[0][1] = Knight.new(self, [0,1], :black)
    @board[0][2] = Bishop.new(self, [0,2], :black)    
    @board[0][4] = King.new(self, [0,4], :black)  
    @board[0][3] = Queen.new(self, [0,3], :black)      
    @board[0][5] = Bishop.new(self, [0,5], :black)      
    @board[0][6] = Knight.new(self, [0,6], :black)      
    @board[0][7] = Rook.new(self, [7,7], :black)      
    @board[7][0] = Rook.new(self, [7,0], :white)
    @board[7][1] = Knight.new(self, [7,1], :white)
    @board[7][2] = Bishop.new(self, [7,2], :white)    
    @board[7][4] = King.new(self, [7,4], :white)  
    @board[7][3] = Queen.new(self, [7,3], :white)      
    @board[7][5] = Bishop.new(self, [7,5], :white)      
    @board[7][6] = Knight.new(self, [7,6], :white)      
    @board[7][7] = Rook.new(self, [7,7], :white)
    [1,6].each do |row|
      (0..7).each do |col|
        if row == 1
          @board[1][col] = Pawn.new(self,[1,col],:black)
        elsif row == 6
          @board[6][col] = Pawn.new(self,[6,col],:white)
        end
      end
    end          
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
        return true if pos == king(color).position
      end
    end
    false
  end
  
  def king(color)
    @board.flatten.find{ |piece| piece.is_a?(King) && piece.color == color }
  end
  
  def same_color?(pos1, pos2)
    self[pos1].color == self[pos2].color    
  end
  
  def diff_color?(pos1, pos2)
    !same_color?(pos1, pos2)
  end
  
  def to_s
    @board.map do |row|
      row.map {|tile| tile.nil? ? "*" : tile.to_s}.join(" ")
    end.join("\n")    
  end 
  
  def dup
    new_board = Board.new
    dupped_board = Array.new(8) { Array.new(8) }
    (0..7).each do |row|
      (0..7).each do |col|
        unless @board[row][col].nil?
          dupped_board[row][col] = @board[row][col].dup(new_board)
        end
      end
    end
    new_board.board = dupped_board
    new_board
  end
  
  def checkmate?
    [:white,:black].each do |color|
      next unless in_check?(color)
      return color if pieces(color).all? { |piece| piece.valid_moves.empty?}
    end
    false
  end
      
  def pieces(color)
    @board.flatten.select {|piece| !piece.nil? && piece.color == color}
  end

  
end