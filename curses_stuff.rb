require "curses"
include Curses

def initialize_screen
  init_screen
  noecho
  crmode
  cbreak
  raw
  stdscr.keypad(true)
  setpos(0,0)
  start_color
  init_pair(1,COLOR_BLUE,COLOR_CYAN) # WALL, #V_BORDER, #H_BORDER, #C_BORDER
  init_pair(2,COLOR_WHITE,COLOR_RED) # MONSTER
  init_pair(3,COLOR_WHITE,COLOR_GREEN) # USER
  init_pair(4,COLOR_WHITE,COLOR_BLACK) # EMPTY
  init_pair(5,COLOR_WHITE,COLOR_YELLOW) # EXIT, ENTRANCE
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
        when 0
          attron(color_pair(1)) {
            addstr(WALL_CHAR)
          }
        when 1
          attron(color_pair(4)) {
            addstr(EMPTY_CHAR)
          }
        when 2 then addstr(GROUND_CHAR)
        when 3
          attron(color_pair(1)) {
            addstr(V_BORDER_CHAR)
          }
        when 4
          attron(color_pair(1)) {
            addstr(H_BORDER_CHAR)
          }
        when 5
          attron(color_pair(1)) {
            addstr(C_BORDER_CHAR)
          }
        when 6
          attron(color_pair(3)) {
            addstr(USER_CHAR)
          }
        when 7
          attron(color_pair(5)) {
            addstr(EXIT_CHAR)
          }
        when 8
          attron(color_pair(2)) {
            addstr(MONSTER_CHAR)
          }
        when 9
          attron(color_pair(5)) {
            addstr(ENTRANCE_CHAR)
          }
      end
    end
    addstr("\n")
    i += 1
  end
  refresh
end

def show_game_over(getname)
  clear
  setpos((lines-5)/2,(cols-10)/2)
  addstr("GAME OVER")
  setpos((lines-5)/2+2,(cols-10)/2)
  if getname
    addstr("Enter your name : ")
    echo
    $name = getstr
    noecho
  else
    getch
  end
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
  setpos(y + 5, x)
  addstr("Highscore : #{$highscore}")
  setpos(y + 6, x)
  addstr("Name : #{$name}")
  refresh
  loop {
    cmd = getch
    case cmd
    when "1" then return
    when "2"
      Sound.play("ok.wav", Sound::ASYNC)
      show_credits
    when "3"
      Sound.play("ok.wav")
      exit 0
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