#!/usr/bin/env ruby
require './board.rb'
require './fancy_board.rb'
require 'debugger'

class Game
  attr_accessor :board, :current_player
  def initialize(player1 = Human.new(:white), player2 = Human.new(:black))
    @player1 = player1
    @player2 = player2
    #debugger
    @window = Window.new(self)
    @board = Board.new(@window)
    @current_player = @player1
    @window.board = @board    
  end
  
  def play
    until @board.checkmate?
      @current_player.play_turn(@board)
      @current_player = ( @current_player == @player1 ? @player2 : @player1 )
    end
    puts "Game over, #{@board.checkmate?} loses"
  end
  
  def change_player
    @current_player = ( @current_player == @player1 ? @player2 : @player1 )
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
     # debugger
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

if __FILE__ == $PROGRAM_NAME
  Game.new.board.show
end
  
  
  
  

  