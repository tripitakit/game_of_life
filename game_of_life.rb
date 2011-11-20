require 'rubygame'

include Rubygame
include Rubygame::Events
include Rubygame::EventActions
include Rubygame::EventTriggers  

require './world'
require './cell'
require './patterns.rb'

include Patterns        
 
$SCREEN_X = 800
$SCREEN_Y = 600
$CELL_SIZE = 5 

$world_rows = ($SCREEN_Y / $CELL_SIZE) - ($SCREEN_Y / $CELL_SIZE)/10 - $CELL_SIZE * 2
$world_cols = ($SCREEN_X / $CELL_SIZE) - ($SCREEN_X / $CELL_SIZE)/10 - $CELL_SIZE * 2 
 
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
    catch([:quit, :edit_mode]) do
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
      :escape => :quit,
      :q => :quit,
      QuitRequested => :quit,
    }
 
    make_magic_hooks( hooks )
  end
       
  def make_queue
    @queue = EventQueue.new()
    @queue.enable_new_style_events
    # @queue.ignore = [MouseMoved]
  end   
       
  
  def make_screen
     @screen = Screen.open( [$SCREEN_X, $SCREEN_Y] )
     @screen.title = "3PI::RubyGameOfLife"
  end
  
  def make_world 
   @world = World.new($world_rows, $world_cols, @screen)
  end
  
  
  def freeze_unfreeze
    @running = @running ? false  : true
  end  
      
  def quit
    throw :quit
  end
  
  def resume
    @running = true
  end
     
  
  # main game step
  def step
    @screen.fill(:black)
    
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

