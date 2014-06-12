require './piece.rb'
require 'debugger'
require 'gosu'

class Board
  attr_accessor :board, :window
  def initialize(window)
    @board = Array.new(8) { Array.new(8) }
    @window = window
    place_pieces
    create_chess_columns        
  end
  
  def draw
    @board.flatten.each do |tile|
      tile.draw unless tile.nil?
    end
  end
  
  def show
    @window.show
  end
  
  CHESS_COLUMNS = {}
  
  def create_chess_columns
    CHESS_COLUMNS["a"] = 0
    CHESS_COLUMNS["b"] = 1
    CHESS_COLUMNS["c"] = 2
    CHESS_COLUMNS["d"] = 3
    CHESS_COLUMNS["e"] = 4
    CHESS_COLUMNS["f"] = 5
    CHESS_COLUMNS["g"] = 6
    CHESS_COLUMNS["h"] = 7
  end
    
  
  def place_pieces
    @board[0][0] = Rook.new(self, [0,0], :black, @window)
    @board[0][1] = Knight.new(self, [0,1], :black, @window)
    @board[0][2] = Bishop.new(self, [0,2], :black, @window)    
    @board[0][4] = King.new(self, [0,4], :black, @window)
    @board[0][3] = Queen.new(self, [0,3], :black, @window)     
    @board[0][5] = Bishop.new(self, [0,5], :black, @window)      
    @board[0][6] = Knight.new(self, [0,6], :black, @window)      
    @board[0][7] = Rook.new(self, [0,7], :black, @window)    
    @board[7][0] = Rook.new(self, [7,0], :white, @window)
    @board[7][1] = Knight.new(self, [7,1], :white, @window)
    @board[7][2] = Bishop.new(self, [7,2], :white, @window)    
    @board[7][4] = King.new(self, [7,4], :white, @window) 
    @board[7][3] = Queen.new(self, [7,3], :white, @window)      
    @board[7][5] = Bishop.new(self, [7,5], :white, @window)      
    @board[7][6] = Knight.new(self, [7,6], :white, @window)      
    @board[7][7] = Rook.new(self, [7,7], :white, @window)
    [1,6].each do |row|                          
      (0..7).each do |col|
        if row == 1
          @board[1][col] = Pawn.new(self,[1,col],:black, @window)
        elsif row == 6
          @board[6][col] = Pawn.new(self,[6,col],:white, @window)
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
    return nil unless (0..7).include?(row) && (0..7).include?(col)
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
  
  def stalemate?(color)
    stalemate = false
    valid_pieces = self.pieces(color).select {|piece| !piece.valid_moves.empty?}
    if valid_pieces.empty? && !in_check?(color)
      stalemate = true 
    end
    stalemate
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
    new_board = Board.new(nil)
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
  
  def parse_position(pos)
    if pos.empty? || pos.size != 2
      raise ArgumentError, "invalid format, correct format is 'a7', 'f3', etc..."
    end
    
    col,row = pos.split("")
    if !(('a'..'h').include?(col) && (1..8).include?(row.to_i))
      raise ArgumentError, "invalid format, correct format is 'a7', 'f3', etc..."
    else
      col = CHESS_COLUMNS[col]
      row = 8 - row.to_i 
      [row, col]
    end
  end 
  
  def display 
    board_str = []
    board_str << "  " + ('a'..'h').map{ |ltr| ltr.colorize(:red) }.to_a.join(' ')
    
    @board.each_with_index do |row, ndx|
      board_str << "#{8 - ndx} ".colorize(:red) + row.map do |tile|
        tile.nil? ? "*" : tile.to_s
      end.join(" ")
    end
    puts board_str.join("\n")
  end 
end