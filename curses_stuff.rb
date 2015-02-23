require "curses"
include Curses

def initialize_screen
  init_screen
  noecho
  crmode
  cbreak
  stdscr.keypad(true)
  setpos(0,0)
end

def show_map(map)
  clear
  setpos(0,0)
  addstr("Room ##{map.id}")
  i = 0
  map.cells.each do |row|
    setpos(i, 30)
    row.each do |cell|
      case cell.status
        when 0 then addstr(WALL_CHAR)
        when 1 then addstr(EMPTY_CHAR)
        when 2 then addstr(GROUND_CHAR)
        when 3 then addstr(V_BORDER_CHAR)
        when 4 then addstr(H_BORDER_CHAR)
        when 5 then addstr(C_BORDER_CHAR)
        when 6 then addstr(USER_CHAR)
        when 7 then addstr(EXIT_CHAR)
        when 8 then addstr(MONSTER_CHAR)
        when 9 then addstr(ENTRANCE_CHAR)
      end
    end
    addstr("\n")
    i += 1
  end
  refresh
end

def show_game_over
  clear
  setpos((lines-5)/2,(cols-10)/2)
  addstr("GAME OVER")
  refresh
  getch
end

def show_menu
  clear
  y = (lines - 5) / 2
  x = (cols - 10) / 2
  setpos(y, x)
  addstr("Hello!")
  setpos(y + 1, x)
  addstr("1 - Play")
  setpos(y + 2, x)
  addstr("2 - Credits")
  setpos(y + 3, x)
  addstr("3 - Quit")
  refresh
  loop {
    cmd = getch
    case cmd
    when "1" then return
    when "2" then show_credits
    when "3" then exit 0
    end
  }
end

def show_credits
  clear
  y = (lines - 5) / 2
  x = (cols - 10) / 2
  setpos(y, x)
  addstr("Made by  : kpwbo")
  setpos(y + 1, x)
  addstr("Help by  : 6112")
  setpos(y + 2, x)
  addstr("Language : Ruby")
  setpos(y + 3,x)
  addstr("Year     : 2015")
  refresh
  getch
  show_menu
end