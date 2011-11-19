require 'rubygame'

include Rubygame
include Rubygame::Events
include Rubygame::EventActions
include Rubygame::EventTriggers  

require './world'
require './cell'
require './patterns.rb'

include Patterns        

$CELL_SIZE = 5 
 
class GameOfLife  
  include EventHandler::HasEventHandler
  
  def initialize(*presets)
    make_screen
    make_clock
    make_queue
    make_event_hooks
    make_world
    presets.each { |preset| send ( preset ) }

  end   
   
  def run!
    catch(:quit) do
      loop do
        step
      end
    end
  end


  private 

  def make_clock
    @clock = Clock.new()
    @clock.target_framerate = 50
    @clock.calibrate
    @clock.enable_tick_events
  end

  def make_event_hooks
    hooks = {
      :c => :clear,
      :r => :random,
      :g => :glider_gun,
      :m => :metuselah,
      :l => :lw_spaceship,        
      :escape => :quit,
      :q => :quit,
      QuitRequested => :quit
    }
 
    make_magic_hooks( hooks )
  end
       
  def make_queue
    @queue = EventQueue.new()
    @queue.enable_new_style_events
    @queue.ignore = [MouseMoved]
  end   
       
  
  def make_screen
     @screen = Screen.open( [800, 600] )
     @screen.title = "3PI::RubyGameOfLife"
  end
  
  def make_world (rows=120, cols=160)
   @world = World.new(rows, cols, @screen)
  end
  
   
  def quit
    throw :quit
  end
     
  def step
    @screen.fill(:black)
    @queue << @clock.tick
    @queue.each do |event|
      handle(event)
    end
    @world.tick!
    @screen.update()
  end
  
   # preset patterns definitions

   def lw_spaceship
      @world.place lightweight_spaceship, 14, 0
   end  

   def metuselah 
      @world.place f_pentomino, 60, 80
   end

   def glider_gun
     @world.place gosper_glider_gun, 20, 20
   end

   def clear
     @world.clear
   end

   def random
     @world.random_sow
   end   

   def four_glider_crash
     @world.place glider,10,10
     @world.place y_mirror(glider), 10, 100 
     @world.place x_mirror(glider), 100, 10
     @world.place xy_mirror(glider), 100, 100
  end     
end  
 

# Start main loop 
GameOfLife.new(:four_glider_crash, :metuselah).run!

# Clean up
Rubygame.quit() 

