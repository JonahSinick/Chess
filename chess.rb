#!/usr/bin/env ruby
require './board.rb'
require './fancy_board.rb'
class Game
  attr_accessor :board, :current_player, :player2
  def initialize(player1 = Human.new(:white), player2 = Human.new(:black))
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
  def initialize(color, strategy = :aggro)
    @color = color
    @strategy = strategy
  end
  
  def other_color
    if @color == :white
      :black
    else
      :white
    end
  end

  def play_turn(board)
    # begin
    from_to = nil
    if @strategy == :point
      # 
      from_to ||= point_move(board)
    end
    if (@strategy == :aggro)
      #from_to ||= check_move(board) if board.pieces(other_color).size < 5
      from_to ||= aggressive_move(board)         
    end
      
    if (@strategy == :max_min)
      from_to ||= max_min_move(board)
    end
      from_to ||= random_move(board)
      from_to[0].move(from_to[1])
      # rescue NoMethodError => err
      #       debugger
      #     end
  end

       
  def random_move(board)
    piece = valid_pieces(board, @color).sample
    move = piece.valid_moves.sample
    [piece, move]    
  end
  
  def aggressive_move(board)
    potential_moves = []
    valid_pieces(board, @color).each do |piece|
      board.pieces(other_color).each do |enemy_piece|
        if piece.valid_moves.include?(enemy_piece.position)
          potential_moves << [piece, enemy_piece.position]
        end
      end
    end
    potential_moves.sample  
  end
  
  def valid_pieces(board, color)
    board.pieces(color).select {|piece| !piece.valid_moves.empty?}
  end
  # 
  # def is_valid?(pos)
  #   test_board = @board.dup
  #   duplicate_piece = test_board[@position]
  #   duplicate_piece.move(pos)
  #   !test_board.in_check?(@color)
  # end
  
  def check_move(board)
    check_moves = []
    valid_pieces(board, @color).each do |piece|
      piece.valid_moves.each do |pos|
        check_moves << [piece, pos] if will_be_in_check?(piece, pos, board)
      end
    end
    check_moves.sample
  end
  
  def point_move(board)
    point_moves = []
    valid_pieces(board, @color).each do |piece|
      piece.valid_moves.each do |pos|
        score = move_score(piece, pos, board, @color)
        point_moves << [piece, pos, score]
      end
    end
    #max by here
    best_move = point_moves.max_by { |piece, pos, score| score }
    
    moves = point_moves.select { |piece, pos, score| score == best_move[2] }
    moves.sample[0..1] 
  end
  
  def max_half_step_points(board, color)
    point_moves = []
    valid_pieces(board, color).each do |piece|
      piece.valid_moves.each do |pos|
        score = move_score(piece, pos, board, color)
        point_moves << [piece, pos, score]
      end
    end
    best_move = point_moves.max_by { |piece, pos, score| score }
    if best_move.nil?
      -100000
    else
      best_move[2]
    end
  end
    
  
  def move_score(piece, pos, board, color)
    simulate_move(piece, pos, board).points(color)
  end
  
  def max_min_move(board)
    master_point_array = []
    valid_pieces(board, @color).each do |piece|
      piece.valid_moves.each do |pos|
        test_board = simulate_move(piece, pos, board)
        master_point_array << [piece, pos, max_half_step_points(test_board, other_color)]
      end
    end
    best_move = master_point_array.min_by { |piece, pos, score| score }
    moves = master_point_array.select { |piece, pos, score| score == best_move[2] }
    moves.sample[0..1]
  end
    
  def simulate_move(piece, pos, board)
    test_board = board.dup
    dup_piece = test_board[piece.position]
    dup_piece.move(pos)
    test_board
  end
  
  
  def will_be_in_check?(piece, pos, board)
    test_board = board.dup
    dup_piece = test_board[piece.position]
    dup_piece.move(pos)
    test_board.in_check?(other_color)
  end
  
end

if __FILE__ == $PROGRAM_NAME
  if ARGV.empty?
    Game.new.board.show
  else
    Game.new.play
  end
end
  