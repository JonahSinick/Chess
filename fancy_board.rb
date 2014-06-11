require 'gosu'
require './chess.rb'
require 'debugger'


class Window < Gosu::Window
  attr_accessor :knight, :board
  def initialize(game)
    super(640, 674, false, 100)
    
    @background_image = Gosu::Image.new(self, "board.png", true)
    @from_pos = nil
    @to_pos = nil
    @white_banner = Gosu::Image.new(self, "white_to_move.png", true)
    @black_banner = Gosu::Image.new(self, "black_to_move.png", true)
    @game = game
  end
  
  def update
    #debugger
    puts "from: #{@from_pos} to: #{@to_pos}"
  end
  
  def button_down(id)
    return if id != Gosu::MsLeft
    if @from_pos.nil?
       @from_pos = pixel_to_board(self.mouse_x, self.mouse_y)
    else
      @to_pos = pixel_to_board(self.mouse_x, self.mouse_y)  
      @board[@from_pos].move(@to_pos) unless @board[@from_pos].nil?
      @game.current_player == :white
      @to_pos = nil
      @from_pos = nil
    end
  end
  
  def draw        
    @background_image.draw(0, 0, 0)
    @board.draw
    if @game.current_player.color == :white
      @white_banner.draw(0, 640, 0)
    else
      @black_banner.draw(0, 640, 0.1)
    end
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
  
end
