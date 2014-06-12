#!/usr/bin/env ruby
require './board.rb'
require './fancy_board.rb'
require 'debugger'

class Game
  attr_accessor :board, :current_player, :player2
  def initialize(player1 = Human.new(:white), player2 = Computer.new(:black))
    @player1 = player1
    @player2 = player2
    #debugger
    @window = Window.new(self, player2.is_a?(Computer))
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
    rescue ArgumentError => err
      #puts "Not a valid position. Correct format 'a4', 'd7', etc..."
      puts err
      retry
    end

    begin
      puts "Enter the square you want to move to."
      # debugger
      to = board.parse_position(gets.chomp)
    rescue ArgumentError => err
      puts err
      #puts "Not a valid position. Correct format 'a4', 'd7', etc..."
      retry
    end
    
    if !board[from].nil? &&
      board[from].color == @color &&
      board[from].valid_moves.include?(to)
      
      board[from].move(to)
    else
      puts "Invalid move"
      play_turn(board)
    end 
  end
  
end

class Computer
  attr_accessor :color
  def initialize(color)
    @color = color
  end
  
  def other_color
    if @color == :white
      :black
    else
      :white
    end
  end

  def play_turn(board)
    valid_pieces = board.pieces(@color).select {|piece| !piece.valid_moves.empty?}
    potential_moves = []
    valid_pieces.each do |piece|
      board.pieces(other_color).each do |enemy_piece|
        if piece.valid_moves.include?(enemy_piece.position)
          potential_moves << [piece, enemy_piece.position]
        end
      end
    end
    if !potential_moves.empty?
      pair = potential_moves.sample  
      pair[0].move(pair[1])
    else
      random_move(board)
    end
  end

       
  def random_move(board)
    valid_pieces = board.pieces(@color).select {|piece| !piece.valid_moves.empty?}
    piece = valid_pieces.sample
    move = piece.valid_moves.sample
    piece.move(move)    
  end

  def is_valid?(pos)
    test_board = @board.dup
    duplicate_piece = test_board[@position]
    duplicate_piece.move(pos)
    !test_board.in_check?(@color)
  end
end

if __FILE__ == $PROGRAM_NAME
  if ARGV.empty?
    Game.new.board.show
  else
    Game.new.play
  end
end
  