require 'gosu'
require './chess.rb'
require 'debugger'


class Window < Gosu::Window
  attr_accessor :knight, :board
  def initialize(game)
    super(640, 700, false, 100)
    
    @background_image = Gosu::Image.new(self, "board.png", true)
    @from_pos = nil
    @white_banner = Gosu::Image.new(self, "white_move.png", true)
    @black_banner = Gosu::Image.new(self, "black_move.png", true)
    @game = game
    @text = Gosu::Font.new(self, 'Verdana', 21)
    @message = "Selected position: "
  end
  
  def update
    #debugger
    puts "from: #{@from_pos} to: #{@to_pos}"
  end
  
  def button_down(id)
    return if id != Gosu::MsLeft
     pos = pixel_to_board(self.mouse_x, self.mouse_y)
     if @board[pos].nil?
       @from_pos = nil
       @message = "Selected position: "
       return
    elsif @board[pos].color == @game.current_player.color
       @from_pos = pos
        @message = "Selected position: " +
        "#{@board[@from_pos].class.to_s.downcase} #{to_chess(@from_pos)}"
    elsif !@from_pos.nil? && @board[@from_pos].is_valid?(pos)
      @board[@from_pos].move(pos)
      @game.change_player
      @from_pos = nil      
      @message = "Selected position: "
    end
   
    @message = "CHECKMATE. #{@board.checkmate?} loses" if @board.checkmate?
  end
  
  def draw        
    @background_image.draw(0, 0, 0)
    @board.draw
    if @game.current_player.color == :white
      @white_banner.draw(0.2, 636, 0)
    else
      @black_banner.draw(0.2, 636, 0.1)
    end
    @text.draw( @message, 262, 672, 1)
  end
  
  def move_knight(x, y)
    @knight 
  end
  
  def needs_cursor?
    true
  end

  def pix_to_board(pixels)
    (pixels / 80).to_i
  end
  
  def pixel_to_board(pixel_x, pixel_y)
    [pixel_y / 80, pixel_x / 80].map(&:to_i)
  end
  
  def board_to_pixel(pos)
    pos.map{ |coord| coord * 80 + 8 }
  end
  
  def to_chess(pos)
    file, row = pos
    row = 8 - row
    file = ('a'..'h').to_a[file]
    file + row.to_s
  end
  
end
