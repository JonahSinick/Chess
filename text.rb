require 'gosu'
class Window < Gosu::Window
  def initialize
    super(640,670,false,100)
    @text = Gosu::Font.new(self, 'Verdana', 20)
  end
  
  def draw
    @text.draw("Hello, text", 20, 640)
  end
  
  def needs_cursor?
    true
  end
end