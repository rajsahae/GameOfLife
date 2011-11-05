# Game of Life
# As described by Conway's Game of Life
# http://en.wikipedia.org/wiki/Conway's_Game_of_Life

class Cell
  attr_reader :x, :y, :world, :state, :next_state

  def initialize(world, x=0, y=0, initial=true)
    @world = world
    @x = x
    @y = y
    @world.cells << self
    @state = initial ? :alive : :dead
    @next_state = nil
  end

  def neighbors
    @world.cells.select do |cell| 
      self.distance_to(cell) < 2 and
      self.distance_to(cell) > 0 and
      cell.alive?
    end
  end

  def distance_to(other_cell)
    ((@x-other_cell.x)**2+(@y-other_cell.y)**2)**0.5
  end

  def spawn_at(x, y, initial = true)
    Cell.new(@world, x, y, initial)
  end

  def kill!
    @next_state = :dead
  end

  def reanimate!
   @next_state = :alive 
  end

  def alive?
    @world.cells.include? self and @state.eql? :alive
  end

  def dead?
    !alive?
  end

  def progress!
    unless @next_state.nil?
      @state = @next_state
      @next_state = nil
    end
  end
  
  def to_s
    self.alive? ? "A" : "D"
  end
end


class World
  attr_reader :cells

  def initialize
    @cells = []
  end

  def tick!
    @cells.each do |cell|
      cell.kill! if cell.neighbors.count < 2 and cell.alive?
      cell.kill! if cell.neighbors.count > 3 and cell.alive?
      cell.reanimate! if cell.neighbors.count == 3 and cell.dead?
    end
    @cells.each{|cell| cell.progress!}
  end

  def range
    x_min = x_max = y_min = y_max = 0
    @cells.each do |cell|
      x_min = cell.x if cell.x < x_min
      x_max = cell.x if cell.x > x_max
      y_min = cell.y if cell.y < y_min
      y_max = cell.y if cell.y > y_max
    end
    [x_min, x_max, y_min, y_max]
  end

  def to_grid
    x_min, x_max, y_min, y_max = self.range
    grid = []
    y_max.downto(y_min) do |y|
      line = ""
      x_min.upto(x_max) do |x|
        cell = self.cell_at(x, y)
        line.concat cell.nil? ? ' ' : cell.to_s
      end
      grid.push line
    end
    grid
  end

  def cell_at(x, y)
    @cells.find{|cell| cell.x == x and cell.y == y}
  end
end
