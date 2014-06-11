require './board.rb'

class Game
  attr_accessor :board
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
  attr_accessor :color
  def initialize(color)
    @color = color
  end
  
  def play_turn(board)
    board.display

    puts "It's #{@color}'s turn. Choose a piece to move."
    puts "You are in check" if board.in_check?(@color)
    begin
      from = board.parse_position(gets.chomp)
    rescue 
      puts "Not a valid position. Correct format 'a4', 'd7', etc..."
      retry
    end

    begin
      puts "Enter the square you want to move to."
      to = board.parse_position(gets.chomp)
    rescue 
      puts "Not a valid position. Correct format 'a4', 'd7', etc..."
      retry
    end
    
    if board[from].valid_moves.include?(to)
      board[from].move(to)
    else
      puts "Invalid move"
      play_turn(board)
    end 
  end
  
end

  