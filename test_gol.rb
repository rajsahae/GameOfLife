require File.expand_path(File.dirname(__FILE__) + '/gol')
require 'test/unit'

class TestGameOfLife < Test::Unit::TestCase

  def setup
    @world = World.new
    @cell = Cell.new(@world)
  end

  def teardown

  end

  def test_cell_to_s
    assert_equal "A", @cell.to_s
    @world.tick!
    assert_equal "D", @cell.to_s
  end

  # "Rule 1: Any live cell with fewer than two live neighbors dies, as if caused by under-population." do
  def test_neighbors_returns_an_array
    assert @cell.neighbors.is_a?(Array)
  end

  def test_neighbors_count_with_no_neighbors
    assert @cell.neighbors.count == 0
  end

  def test_neighbors_count_with_no_close_neighbors
    new_cell = @cell.spawn_at(3, 5)
    assert new_cell.is_a?(Cell)
    assert_equal 0, @cell.neighbors.count
  end
  
  def test_spawn_with_initial_state
    live_cell = Cell.new(@world, 3, 3, true)
    another_live_cell = live_cell.spawn_at(1, 1, true)
    dead_cell = Cell.new(@world, 2, 2, false)
    another_dead_cell = live_cell.spawn_at(5, 5, false)

    assert live_cell.alive?,"Live_cell isn't alive"
    assert another_live_cell.alive?,"Another live cell isn't alive"
    assert dead_cell.dead?,"Dead cell isn't dead"
    assert another_dead_cell.dead?,"Another dead cell isn't dead"
  end

  def test_neighbors_count_with_cell_to_the_north_is_1
    @cell.spawn_at(0, 1)
    @cell.spawn_at(2, 0)
    assert_equal 1, @cell.neighbors.count
  end

  def test_neighbors_count_with_cell_to_the_northeast_is_1
    @cell.spawn_at(1,1)
    assert_equal 1, @cell.neighbors.count
  end

  def test_neighbors_count_with_cell_to_the_east_is_1
    @cell.spawn_at(1, 0)
    assert_equal 1, @cell.neighbors.count
  end

  def test_neighbors_count_with_cell_to_the_west_is_1
    @cell.spawn_at(-1, 0)
    assert_equal 1, @cell.neighbors.count
  end

  def test_neighbors_count_with_cells_on_all_sides_is_8
    -1.upto(1) do |i|
      -1.upto(1) do |j|
        next if i == 0 and j == 0
        @cell.spawn_at(i, j)
      end
    end
    assert_equal 8, @cell.neighbors.count
  end

  def test_live_cell_with_one_live_neighbor_dies
    @cell.spawn_at(0, 1)
    @world.tick!
    assert @cell.dead?
  end

  def test_distance_to_other_cells
    west_cell = @cell.spawn_at(-1, 0)
    west3_cell = @cell.spawn_at(-3, 0)
    north_east_cell = @cell.spawn_at(1,1)

    assert_same 1, @cell.distance_to(west_cell).to_i
    assert_same 3, @cell.distance_to(west3_cell).to_i
    assert_in_delta 2**0.5, @cell.distance_to(north_east_cell), 0.0001
  end

  def test_cell_with_two_neighbors_lives
    new_cell = @cell.spawn_at(1, 0)
    other_new_cell = @cell.spawn_at(-1, 0)
    @world.tick!
    assert @cell.alive?
  end

  def test_cell_with_4_neighbors_dies
    first_cell = @cell.spawn_at(1,0)
    second_cell = @cell.spawn_at(1,1)
    third_cell = @cell.spawn_at(0,1)
    fourth_cell = @cell.spawn_at(-1,1)
    @world.tick!
    assert @cell.dead?, "Cell is not dead."
  end

  def test_dead_cell_with_3_live_neighbors_becomes_live
    first_cell = @cell.spawn_at(1,0)
    second_cell = @cell.spawn_at(1,1)
    third_cell = @cell.spawn_at(0,1)
    @cell.kill!
    @cell.progress!
    @world.tick!
    assert @cell.alive?, "Cell is not alive."
  end

  def test_cross_oscillator
    top_cell = @cell.spawn_at(0, 1, false)
    right_cell = @cell.spawn_at(1, 0, true)
    bottom_cell = @cell.spawn_at(0, -1, false)
    left_cell = @cell.spawn_at(-1, 0, true)

    assert right_cell.alive?, "Right Cell isn't alive"
    assert left_cell.alive?, "Left Cell isn't alive"
    assert top_cell.dead?, "Top Cell isn't dead"
    assert bottom_cell.dead?, "Bottom Cell isn't dead"
    assert @cell.alive?, "Center cell isn't alive."

    assert_equal 3, top_cell.neighbors.count
    assert_equal 3, bottom_cell.neighbors.count
    assert_equal 1, right_cell.neighbors.count
    assert_equal 1, left_cell.neighbors.count
    assert_equal 2, @cell.neighbors.count
    
    @world.tick!

    assert right_cell.dead?, "Right Cell isn't dead"
    assert left_cell.dead?, "Left Cell isn't dead"
    assert top_cell.alive?, "Top Cell isn't alive"
    assert bottom_cell.alive?, "Bottom Cell isn't alive"
    assert @cell.alive?, "Center Cell isn't alive"

    @world.tick!

    assert right_cell.alive?, "Right Cell isn't alive"
    assert left_cell.alive?, "Left Cell isn't alive"
    assert top_cell.dead?, "Top Cell isn't dead"
    assert bottom_cell.dead?, "Bottom Cell isn't dead"
    assert @cell.alive?, "Center cell isn't alive."
  end

  def test_grid_range
    assert_equal [0, 0, 0, 0], @world.range
    @cell.spawn_at(1, 0)
    assert_equal [0, 1, 0, 0], @world.range
    @cell.spawn_at(-1, -1)
    @cell.spawn_at(1, 5)
    assert_equal [-1, 1, -1, 5], @world.range 
  end

  def test_world_to_grid
    top_cell = @cell.spawn_at(0, 1, true)
    right_cell = @cell.spawn_at(1, 0, true)
    bottom_cell = @cell.spawn_at(0, -1, true)
    left_cell = @cell.spawn_at(-1, 0, true)

    output = [" A ", "AAA", " A "] 
    assert_equal output, @world.to_grid

    top_cell.kill!
    bottom_cell.kill!
    top_cell.progress!
    bottom_cell.progress!

    output = [" D ", "AAA", " D "]
    assert_equal output, @world.to_grid
  end

  def test_world_cell_at
    second_cell = @cell.spawn_at(1,1)
    third_cell = @cell.spawn_at(-1,-1)

    assert_equal @cell, @world.cell_at(0,0)
    assert_equal second_cell, @world.cell_at(1, 1)
    assert_equal third_cell, @world.cell_at(-1,-1)
  end
end

