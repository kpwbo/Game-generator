require_relative "Game"

MAX_SIZE = 24 # even number, the map is a "square"
$monster_speed = 1 # the higher the number, the more difficult the game is

# How the characters look like
WALL_CHAR = " "
EMPTY_CHAR = " "
GROUND_CHAR = "."
V_BORDER_CHAR = " "
H_BORDER_CHAR = " "
C_BORDER_CHAR = " "
USER_CHAR = "@"
EXIT_CHAR = "x"
MONSTER_CHAR = "O"
ENTRANCE_CHAR = "!"

# HIGHSCORE
$highscore = 0
$name = ""

initialize_screen

loop do
  show_menu
  pick_difficulty
  game = Game.new
  game.print_map
  loop do
    result = game.play_turn
    if result.first == "game over"
      getname = false
      if game.current_map > $highscore
        $highscore = game.current_map
        getname = true
      end
      game.game_over(getname)
      break
    elsif result.first == "change map"
      game.clear_current_map
      game.current_map = result[1]
      game.user_x = result[2]
      game.user_y = result[3]
      game.place_user
      game.place_monster
      game.print_map
    elsif result.first == "user moved"
      setpos(game.user_x, 30+game.user_y)
      attron(color_pair(3)) {
            addstr(USER_CHAR)
          }
    end
  end
end
getch