require_relative "Cell"

class Map
  attr_accessor :cells, :exits, :id
	
  def initialize(id, status=WALL)
    @cells = Array.new(MAX_SIZE) { Array.new(MAX_SIZE) }
    (0...MAX_SIZE).each do |i|
      (0...MAX_SIZE).each do |j|
        @cells[i][j] = Cell.new(i,j,status)
      end
    end
		@id = id
		@exits = {}
  end

  def set_empty(cell)
    @cells[cell.coord.x][cell.coord.y].status = EMPTY
  end

  def clear_map
    (1...MAX_SIZE-1).each do |i|
      (1...MAX_SIZE-1).each do |j|
        c = @cells[i][j]
        neighs = find_neighbours(c)
        set = true
        neighs.each do |neigh|
          set = false if neigh.status == WALL
        end
        set_empty(c) if set
      end
    end
  end

  def find_neighbours(cell)
    neighs = []
    neighs << @cells[cell.coord.x-1][cell.coord.y] if Cell.new(cell.coord.x-1,cell.coord.y).valid?
    neighs << @cells[cell.coord.x][cell.coord.y-1] if Cell.new(cell.coord.x,cell.coord.y-1).valid?
    neighs << @cells[cell.coord.x][cell.coord.y+1] if Cell.new(cell.coord.x,cell.coord.y+1).valid?
    neighs << @cells[cell.coord.x+1][cell.coord.y] if Cell.new(cell.coord.x+1,cell.coord.y).valid?
    neighs
  end
	
	def generate_path(start_x, start_y, num_paths=1, door=false, door_x=0, door_y=0)
		@exits[[door_x, door_y]] = 0 unless door == false
		(0...num_paths).each do
			current_cell = Cell.new(start_x,start_y)
			cells[door_x][door_y].status = ENTRANCE if door
			set_empty(current_cell)
			walls = []
			walls = find_neighbours(current_cell)
			until walls.empty? do
				wall = walls.sample
				next_cell = current_cell.opposite(wall)
				if next_cell.status == WALL
					set_empty(wall)
					set_empty(next_cell)
					walls = find_neighbours(next_cell)
				end
				walls.delete_if do |item|
					item.coord.x == wall.coord.x && item.coord.y == wall.coord.y
				end
				current_cell = next_cell
			end
			@exits[[current_cell.coord.x, current_cell.coord.y]] = 0
			clear_map
		end
		cells.first.each { |cell| cell.status = EXIT if cell.status == EMPTY }
		cells.last.each { |cell| cell.status = EXIT if cell.status == EMPTY }
		cells.each { |row| row.first.status = EXIT if row.first.status == EMPTY }
		cells.each { |row| row.last.status = EXIT if row.last.status == EMPTY }
	end

end