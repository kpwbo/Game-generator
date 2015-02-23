require_relative "Coord"

WALL = 0
EMPTY = 1
GROUND = 2
V_BORDER = 3
H_BORDER = 4
C_BORDER = 5
USER = 6
EXIT = 7
MONSTER = 8
ENTRANCE = 9

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