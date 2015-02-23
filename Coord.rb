require_relative "curses_stuff"

class Coord
	attr_accessor :x, :y

	def initialize(x,y)
		@x = x
		@y = y
	end
	
end