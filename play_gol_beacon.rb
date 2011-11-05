require File.expand_path(File.dirname(__FILE__) + '/gol')
require File.expand_path(File.dirname(__FILE__) + '/gol_player')

myWorld = World.new
center_cell = Cell.new(myWorld, 0, 0)
center_cell.spawn_at(0,1)
center_cell.spawn_at(-1,0)
center_cell.spawn_at(-1,1)
center_cell.spawn_at(1,-1)
center_cell.spawn_at(1,-2)
center_cell.spawn_at(2,-1)
center_cell.spawn_at(2,-2)

beacon = GOLPlayer.new(myWorld)
beacon.play
