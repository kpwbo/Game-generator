require_relative "Game"
require "win32/sound"
include Win32

MAX_SIZE = 24 # even number, the map is a "square"
MONSTER_MOVEMENT_PER_TURN = 1 # number of steps taken by the monster every turn. If 0, the monster doesn't move.

# How the characters look like
WALL_CHAR = "#"
EMPTY_CHAR = " "
GROUND_CHAR = "."
V_BORDER_CHAR = "#"
H_BORDER_CHAR = "#"
C_BORDER_CHAR = "#"
USER_CHAR = "@"
EXIT_CHAR = "x"
MONSTER_CHAR = "O"
ENTRANCE_CHAR = "!"

initialize_screen

loop do
  show_menu
  Sound.play("romans.wav")
  game = Game.new
  game.print_map
  #Sound.play("038-Dungeon04.wav", Sound::ASYNC|Sound::LOOP)
  Thread.new {
      Sound.play("dungeon.wav", Sound::ASYNC | Sound::LOOP)
    }
  loop do
    result = game.play_turn
    if result.first == "game over"
      Sound.play("falling.wav", Sound::ASYNC)
      game.game_over
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
      addstr(USER_CHAR)
    end
  end
end
getch