require_relative "Game"
require "win32/sound"
include Win32

MAX_SIZE = 50 # even number, the map is a "square"
MONSTER_MOVEMENT_PER_TURN = 3 # the higher the number, the more difficult the game is

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
  Sound.play("romans.wav")
  game = Game.new
  game.print_map
  Thread.new {
      Sound.play("dungeon.wav", Sound::ASYNC | Sound::LOOP)
    }
  loop do
    result = game.play_turn
    if result.first == "game over"
      getname = false
      if game.current_map > $highscore
        $highscore = game.current_map
        getname = true
      end
      Sound.play("falling.wav", Sound::ASYNC)
      game.game_over(getname)
      break
    elsif result.first == "change map"
      #Sound.play("apert2.wav", Sound::ASYNC)
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