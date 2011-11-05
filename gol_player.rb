require File.expand_path(File.dirname(__FILE__) + '/gol')

class GOLPlayer
  def initialize(gol_world)
    @world = gol_world
  end

  def play
    while true
      puts @world.to_grid.map{|line| line.gsub(/A/,'*').gsub(/D/, ' ')}
      puts "\n"
      @world.tick!
      sleep(1)
    end
  end
    
end
