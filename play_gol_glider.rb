require File.expand_path(File.dirname(__FILE__) + '/gol')
require File.expand_path(File.dirname(__FILE__) + '/gol_player')

myWorld = World.new
center_cell = Cell.new(myWorld, 0, 0)
center_cell.spawn_at(2,1)
center_cell.spawn_at(2,0)
center_cell.spawn_at(2,-1)
center_cell.spawn_at(1,-1)

glider = GOLPlayer.new(myWorld)
glider.play
