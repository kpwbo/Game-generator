require_relative "Map"

class Game
  attr_accessor :maps, :previous_map, :current_map, :user_x, :user_y, :monster_x, :monster_y

  def initialize
    @maps = []
    @previous_map = 0
    @current_map = 1
    @user_x = 1
    @user_y = 1
    @monster_x = 0
    @monster_y = 0
    generate_new_map(@current_map)
    @maps[@current_map].generate_path(@user_x, @user_y)
    place_user
    place_monster
  end

  def generate_new_map(id)
    map = Map.new(id)
    map.cells.first.each { |cell| cell.status = H_BORDER } # top border
    map.cells.last.each { |cell| cell.status = H_BORDER } # bottom border
    map.cells.each { |row|
      row.first.status = V_BORDER # left border
      row.last.status = V_BORDER # right border
    }
    map.cells.first.first.status = C_BORDER # top left corner
    map.cells.first.last.status = C_BORDER # top right corner
    map.cells.last.first.status = C_BORDER # bottom left corner
    map.cells.last.last.status = C_BORDER # bottom right corner
    @maps[id] = map
  end

  def place_user
    @maps[@current_map].cells[@user_x][@user_y].status = USER
  end

  def place_monster
    loop do
      cell = @maps[@current_map].cells.sample.sample
      if cell.status == EMPTY
        @monster_x = cell.coord.x
        @monster_y = cell.coord.y
        break
      end
    end
    @maps[@current_map].cells[@monster_x][@monster_y].status = MONSTER
  end

  def clear_user
    @maps[@current_map].cells[@user_x][@user_y].status = EMPTY
  end

  def clear_monster
    @maps[@current_map].cells[@monster_x][@monster_y].status = EMPTY
  end

  def clear_current_map
    clear_user
    clear_monster
  end

  def move_user(result)
    next_user_x = @user_x
    next_user_y = @user_y
    # Get user input
    cmd = getch
    case cmd
      when KEY_UP then next_user_x -= 1
      when KEY_DOWN then next_user_x += 1
      when KEY_LEFT then next_user_y -= 1
      when KEY_RIGHT then next_user_y += 1
      when "q" then exit 0
    end
    # Avoid segmentation fault
    next_user_x += MAX_SIZE if next_user_x < 0
    next_user_x = MAX_SIZE - next_user_x if next_user_x >= MAX_SIZE
    next_user_y += MAX_SIZE if next_user_y < 0
    next_user_y = MAX_SIZE - next_user_y if next_user_y >= MAX_SIZE
    # Check if movement is possible
    case @maps[@current_map].cells[next_user_x][next_user_y].status
      when EMPTY
        clear_user
        @user_x = next_user_x
        @user_y = next_user_y
        place_user
        result << "user moved"
      when MONSTER
        result << "game over"
      when EXIT
        next_map_id = 0
        if @maps[@current_map].exits[[next_user_x, next_user_y]] == 0
          next_map_id = @maps.count
          @maps[@current_map].exits[[next_user_x, next_user_y]] = next_map_id
          generate_new_map(next_map_id)
          if next_user_x == 0
            next_user_x = MAX_SIZE-2
            next_door_x = MAX_SIZE-1
            next_door_y = next_user_y
          elsif next_user_x == MAX_SIZE-1
            next_user_x = 1
            next_door_x = 0
            next_door_y = next_user_y
          elsif next_user_y == 0
            next_user_y = MAX_SIZE-2
            next_door_x = next_user_x
            next_door_y = MAX_SIZE-1
          elsif next_user_y == MAX_SIZE-1
            next_user_y = 1
            next_door_x = next_user_x
            next_door_y = 0
          end
          @maps[next_map_id].generate_path(next_user_x, next_user_y, rand(1..2), true, next_door_x, next_door_y)
          @maps[next_map_id].exits[[next_door_x, next_door_y]] = @current_map
          @maps[next_map_id].cells[next_door_x][next_door_y].status = EXIT
        else
          next_map_id = @maps[@current_map].exits[[next_user_x,next_user_y]]
          if next_user_x == 0
            next_user_x = MAX_SIZE-2
            next_door_x = MAX_SIZE-1
            next_door_y = next_user_y
          elsif next_user_x == MAX_SIZE-1
            next_user_x = 1
            next_door_x = 0
            next_door_y = next_user_y
          elsif next_user_y == 0
            next_user_y = MAX_SIZE-2
            next_door_x = next_user_x
            next_door_y = MAX_SIZE-1
          elsif next_user_y == MAX_SIZE-1
            next_user_y = 1
            next_door_x = next_user_x
            next_door_y = 0
          end
        end
        result << "change map"
        result << next_map_id
        result << next_user_x
        result << next_user_y
    end
  end

  def move_monster(result)
    previous_monster_x = @monster_y
    previous_monster_y = @monster_x
    (1..MONSTER_MOVEMENT_PER_TURN).each do |i|
      monster_possibilities = @maps[@current_map].find_neighbours(Cell.new(@monster_x,@monster_y))
      monster_possibilities.delete_if { |item|
        item.status == WALL
      }
      monster_possibilities.delete_if { |item| item.coord.x == previous_monster_x && item.coord.y == previous_monster_y } unless monster_possibilities.count <= 1
      new_monster = monster_possibilities.sample
      loop {
        break if new_monster.status != WALL
        new_monster = monster_possibilities.sample
      }
      @maps[@current_map].cells[@monster_x][@monster_y].status = EMPTY
      previous_monster_x = @monster_x
      previous_monster_y = @monster_y
      @monster_x = new_monster.coord.x
      @monster_y = new_monster.coord.y
      @maps[@current_map].cells[@monster_x][@monster_y].status = MONSTER
      if @monster_x == @user_x && @monster_y == @user_y
        result[0] = "game over"
      end
    end
  end

  def play_turn
    result = []
    print_map
    move_user(result)
    move_monster(result)
    result
  end

  def print_map
    show_map(@maps[@current_map])
  end

  def game_over
    show_game_over
  end

end