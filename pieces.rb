load "./piece.rb"
require "colorize"
require 'debugger'
class Bishop < Piece
  @max_distance = 8

  def initialize(board, position, color, window)
    @board = board
    @position = position
    @color = color
    if !window.nil?
      @image =  Gosu::Image.new(window, color.to_s[0] + "b.png",false)
    end
    @value = 3
  end
  
  def move_dirs
    DIAGONALS
  end
  def to_s
    if self.color == :black
      "B"
    else
      "B".colorize(:blue)
    end
  end
end

class Rook < Piece
  @max_distance = 8
  
  def initialize(board, position, color, window)
    @board = board
    @position = position
    @color = color
    if !window.nil?
      @image =  Gosu::Image.new(window, color.to_s[0] + "r.png",false)
    end
    @value = 5
  end
  
  def move_dirs
    HORVERTS
  end
  
  def to_s
    if self.color == :black
      "R"
    else
      "R".colorize(:blue)
    end
  end
end

class Queen < Piece
  @max_distance = 8
  
  def initialize(board, position, color, window)
    @board = board
    @position = position
    @color = color
    if !window.nil?
      @image =  Gosu::Image.new(window, color.to_s[0] + "q.png",false)
    end
    @value = 9
  end
  
  def move_dirs
    DIAGONALS + HORVERTS
  end
  
  def to_s
    if self.color == :black
      "Q"
    else
      "Q".colorize(:blue)
    end
  end
end


class King < Piece
  @max_distance = 1

  def initialize(board, position, color, window)
    @board = board
    @position = position
    @color = color
    if !window.nil?
      @image =  Gosu::Image.new(window, color.to_s[0] + "k.png",false)
    end
  end
  
  def move_dirs
    DIAGONALS + HORVERTS
  end
  
  def to_s
    if self.color == :black
      "K"
    else
      "K".colorize(:blue)
    end
  end
end

class Knight < Piece
  @max_distance = 1
  
  def initialize(board, position, color, window)
    @board = board
    @position = position
    @color = color
    if !window.nil?
      @image =  Gosu::Image.new(window, color.to_s[0] + "n.png",false)
    end
    @value = 3
  end
    
  def move_dirs
    [ [-2, -1], [2, -1], [-2, 1], [2, 1], [-1, -2], [1, -2], [-1, 2], [1, 2]]
  end
  
  def to_s
    if self.color == :black
      "N"
    else
      "N".colorize(:blue)
    end
  end
end

class Pawn < Piece
  
  
  def initialize(board, position, color, window)
    @board = board
    @position = position
    @color = color
    @window = window
    if !window.nil?
      @image =  Gosu::Image.new(window, color.to_s[0] + "p.png",false)
    end
    @at_initial_position = true
    @direction = (color == :black ? 1 : -1)
    @value = 1
  end
  
  def move(pos)
    super
    @at_initial_position = false
    if @color == :white && @position[0] == 0
      promote
    end
    if @color == :black && @position[0] == 7
      promote
    end
  end
  
  
  def promote
    p = "Q" #["N","B","R","Q"].sample
    if p == "N" #for now
      @board[@position] = Knight.new(@board, @position, @color, @window)
    elsif p == "B"
      @board[@position] = Bishop.new(@board, @position, @color, @window)
    elsif p == "R"
      @board[@position] = Rook.new(@board, @position, @color, @window)
    elsif p == "Q"
      @board[@position] = Queen.new(@board, @position, @color, @window)
    else
      puts "That's not a valid piece name! Enter 'N', 'B', 'R' or 'Q'"
    end
  end
  
  
  def possible_moves
    #debugger
    positions = []
    one_forward = [@position[0] + (1 * @direction), @position[1] ]
    two_forward = [@position[0] + (2 * @direction), @position[1] ]
    if @board[one_forward].nil?
      positions << one_forward
      if @at_initial_position && @board[two_forward].nil?
        positions << two_forward
      end
    end
    diags.each do |diag|
      if !@board[diag].nil? && @board[diag].color != @color
        positions << diag
      end
    end
    positions.select { |row,column| in_board?(row, column)}
  end
  
  def diags
    left_diag = [@position[0] + @direction , @position[1] - 1]
    right_diag = [@position[0] + @direction, @position[1] + 1]
    [left_diag, right_diag]
  end
  
  def to_s
    if self.color == :black
      "P"
    else
      "P".colorize(:blue)
    end
  end
end

