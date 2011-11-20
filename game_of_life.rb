require 'rubygame'

include Rubygame
include Rubygame::Events
include Rubygame::EventActions
include Rubygame::EventTriggers  

require './world'
require './cell'
require './patterns.rb'

include Patterns        
 
$world_rows = 60
$world_cols = 80

$CELL_SIZE = 9 
$SCREEN_X = $world_cols * ($CELL_SIZE) + $world_cols
$SCREEN_Y = $world_rows * ($CELL_SIZE) + $world_rows

 
class GameOfLife  
  include EventHandler::HasEventHandler
  
  def initialize(*presets)
    make_screen
    make_queue
    make_event_hooks
    make_world
    presets.each { |preset| send ( preset ) }
  end   
  
  # main loop with infinite loop 
  def run! 
    @running = true
    catch([:quit]) do
      loop do
        step
      end
    end
  end


  private 

  def make_event_hooks
    hooks = {
      :space => :freeze_unfreeze,  
      :b => :breeder,
      :c => :clear,
      :r => :random,
      :g => :glider_gun,
      :m => :metuselah,
      :l => :lw_spaceship,
      :f => :four_glider_crash,        
      :mouse_left => :finger_of_god,
      :escape => :quit,
      :q => :quit,
      QuitRequested => :quit
    }
 
    make_magic_hooks( hooks )
  end
       
  def make_queue
    @queue = EventQueue.new()
    @queue.enable_new_style_events
    @queue.ignore = [MouseMoved, MousePressed]
    
  end   
       
  
  def make_screen
     @screen = Screen.open( [$SCREEN_X, $SCREEN_Y] )
     @screen.title = "3PI::RubyGameOfLife"
  end
  
  def make_world 
   @world = World.new($world_rows, $world_cols, @screen)
  end
  
  
  def freeze_unfreeze
   if @running 
     @running = false
     @queue.ignore -= [MouseMoved, MousePressed]
   else
     @running = true 
     @queue.ignore = [MouseMoved, MousePressed]
   end
  end 
  
  def finger_of_god (event)
      col = screen2world event.pos[0] 
      row = screen2world event.pos[1]
      puts "row #{row} ,  col #{col}"
      @world.touch(row,col) 
      
      @screen.update()
  end  
  
  def screen2world(screen_pos)
    screen_x = (x+1)*$CELL_SIZE + x 

    world_pos = screen_position / ($CELL_SIZE + 1)
    
  end
      
  def quit
    throw :quit
  end
  
  def resume
    @running = true
  end
     
  
  
  # main game step
  def step
    @screen.fill([12,24,36])
    
    @queue.each do |event|
      handle(event)
    end
    
    if @running
        @world.tick! 
        @screen.update()
    end
  end 
  
  
  
  
   # preset pattern builders
   def lw_spaceship
      @world.place lightweight_spaceship, $world_rows/2, 0
   end  

   def metuselah 
      @world.place f_pentomino, $world_rows/2, ($world_cols - f_pentomino.width)/2
   end

   def glider_gun
     @world.place gosper_glider_gun, $world_rows/2, ($world_cols - gosper_glider_gun.width)/2
   end

   def clear
     @world.clear
   end

   def random
     @world.random_sow
   end   

   def four_glider_crash
     @world.place glider,1,1
     @world.place y_mirror(glider), 1,  $world_cols - glider.width - 1
     @world.place x_mirror(glider), $world_rows - glider.height, 1
     @world.place xy_mirror(glider), $world_rows - glider.height - 1, $world_cols - glider.width - 1 
  end  
  
  def breeder
    @world.place butterfly, $world_rows/2, ($world_cols - butterfly.width)/2
  end   
end  
 

# Start main loop 
GameOfLife.new().run!

# Clean up
Rubygame.quit() 

