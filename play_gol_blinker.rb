require File.expand_path(File.dirname(__FILE__) + '/gol')
require File.expand_path(File.dirname(__FILE__) + '/gol_player')

myWorld = World.new
center_cell = Cell.new(myWorld, 0, 0)
center_cell.spawn_at(0,1, false)
center_cell.spawn_at(0,-1, false)
center_cell.spawn_at(-1,0)
center_cell.spawn_at(1,0)

blinker_player = GOLPlayer.new(myWorld)
blinker_player.play
