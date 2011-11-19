
  require './patterns.rb'
  require './world'
  require './cell'
  require 'rainbow' 
  
  include Patterns        
  
  
  def spaceships 
     @world.plot lightweight_spaceship, 14, 0
     @world.plot glider, 0,0  
  end  
  
  def metuselah 
   @world.plot f_pentomino, 15, 57
  end
  
  def gosper_glider_gun
    @world.plot gosper_glider_gun, 2, 2
  end
    
  def four_glider_crash 
    @world.plot glider,2,3
    @world.plot y_mirror(glider), 1, @cols-1-glider[0].size
    @world.plot x_mirror(glider), @rows-2-glider.size, 2
    @world.plot xy_mirror(glider), @rows-3-glider.size, @cols-2-glider[0].size 
  end
  
  def random(coverage_ratio)
    @world.random_sow(coverage_ratio)
  end
  
  @rows = 32             
  @cols = 120
  @world = World.new(@rows, @cols)
       
  # four_glider_crash
  # metuselah
  # spaceships
  
  random(0.1)
  @world.run!