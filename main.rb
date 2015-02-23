require_relative "Game"

MAX_SIZE = 24 # even number, the map is a "square"
MONSTER_MOVEMENT_PER_TURN = 1 # number of steps taken by the monster every turn. If 0, the monster doesn't move.

# Do not change these ! To change how they look like, check the "show_map(map)" function in curses_stuff.rb
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

initialize_screen

loop do
	show_menu
	game = Game.new
	loop do
		show_map(game.maps[game.current_map])
		result = game.play_turn
		if result.first == "game over"
			game.game_over
			break
		elsif result.first == "change map"
			game.clear_current_map
			game.current_map = result[1]
			game.user_x = result[2]
			game.user_y = result[3]
			game.place_user
			game.place_monster
		end
	end
end
getch