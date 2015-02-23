require_relative "Coord"

class Cell
  attr_accessor :coord, :status

  def initialize(x,y,status=WALL)
    @coord = Coord.new(x,y)
    @status = status
  end

  def valid?
    !(@coord.x <= 0 || @coord.x >= MAX_SIZE-1 || @coord.y <= 0 || @coord.y >= MAX_SIZE-1)
  end

  def opposite(wall)
    Cell.new(2*wall.coord.x-coord.x,2*wall.coord.y-coord.y)
  end

end