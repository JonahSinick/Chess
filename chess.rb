require './board.rb'

class Game
  def initialize(player1 = Human.new(:white), player2 = Human.new(:black))
    @player1 = player1
    @player2 = player2
    @board = Board.new
    @current_player = @player1
  end
  
  def play
    until @board.checkmate?
      @current_player.play_turn(@board)
      @current_player = ( @current_player == @player1 ? @player2 : @player1 )
    end
    puts "Game over, #{@board.checkmate?} loses"
  end
end

class Human
  attr_acccessor :color
  def initialize(color)
    @color = color
  end
  
  def play_turn(board)
    puts board
    puts "It's #{@color}'s turn. Make a move"
    gets.chomp
  end
  
end

class Display
  def conversion(string)
    h = {}
    h["a"] = 0
    h["b"] = 1
    h["c"] = 2
    h["d"] = 3
    h["e"] = 4
    h["f"] = 5
    h["g"] = 6
    h["h"] = 7
    arr = string.split("")
    h[arr[0]] = col
    7 - h[arr[1].to_i] = 
    "a4a5" --- > [0,3] moves to [0,2]
    
    
  